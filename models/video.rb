module Aji
  class Video
    attr_reader :uid, :source, :keys
    def initialize uid, source='youtube'
      @uid = uid
      @source = source
      prefix = "video:#{@source}[#{@uid}]"
      @keys = { mention_uids:   "#{prefix}:mention_uids",
                mentioner_uids: "#{prefix}:mentioner_uids",
                spam_uids:      "#{prefix}:spam_uids",
                spammer_uids:   "#{prefix}:spammer_uids" }
    end

    Spam_Key = "Video:Spam"

    def spammed_by? mentioner, count=2
      mention_count(mentioner) > count
    end

    def heavily_spammed_by? mentioner
      spammed_by? mentioner, 5
    end

    def mentioned_in mention
      Aji.redis.zincrby @keys[:mentioner_uids], 1, mention.author.uid
      Aji.redis.zadd @keys[:mention_uids], mention.created_at.to_i, mention.uid
      expire_keys
    end

    def mention_count mentioner=nil
      return (Aji.redis.zscore(@keys[:mentioner_uids], mentioner.uid)).to_i if mentioner
      Aji.redis.zcard @keys[:mention_uids]
    end

    def destroy
      expire_keys 0
    end

    def track_spam spam
      Aji.redis.zincrby @keys[:spammer_uids], 1, spam.author.uid
      Aji.redis.zadd @keys[:spam_uids], spam.created_at.to_i, spam.uid
      expire_keys
    end

    def spammed_by_others?
      spammers = Aji.redis.zcard @keys[:spammer_uids]
      mentioners = Aji.redis.zcard @keys[:mentioner_uids]
      spammers > mentioners / 2
    end

    def spam?
      not (Aji.redis.zscore Spam_Key, uid).nil?
    end

    def mark_spam
      Aji.redis.zadd Spam_Key, Time.now.to_i, uid

      # Remove self from trending videos
      trending = Trending.new @source
      trending.remove_video self
    end

    def check_spam spam
      track_spam spam if spammed_by? spam.author
      mark_spam if spammed_by_others? or heavily_spammed_by? spam.author
    end

    def to_s
      ages = []
      Aji.redis.zrevrange(@keys[:mention_uids], 0, 4).each do |mid|
        time = (Aji.redis.zscore @keys[:mention_uids], mid).to_i
        ages << (Time.now.to_i - time)
      end
      mentioner_count = Aji.redis.zcard @keys[:mentioner_uids]

      spam_count = Aji.redis.zcard @keys[:spam_uids]
      spammer_count = Aji.redis.zcard @keys[:spammer_uids]
      spam_ages = []
      Aji.redis.zrevrange(@keys[:spam_uids], 0, 4).each do |mid|
        time = (Aji.redis.zscore @keys[:spam_uids], mid).to_i
        spam_ages << (Time.now.to_i - time)
      end

      "#{@source}[#{@uid}], #{mention_count} mentions (TTL: #{Aji.redis.ttl @keys[:mention_uids]}) "+
      "by #{mentioner_count} authors (TTL: #{Aji.redis.ttl @keys[:mentioner_uids]}) (#{ages.join(', ')})"+
      ", #{spam_count} spams by #{spammer_count} (#{spam_ages.join(', ')})"
    end

    def expire_keys ttl=6.hours
      @keys.each_pair do |name, key|
        Aji.redis.expire key, ttl
      end
    end

    private :expire_keys
  end
end