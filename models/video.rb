module Aji
  class Video
    attr_reader :uid, :source, :keys
    def initialize uid, source='youtube'
      raise "nil uid or source!" if uid.nil? or source.nil?

      @uid = uid
      @source = source
      prefix = "video:#{@source}[#{@uid}]"
      @keys = { mention_uids:   "#{prefix}:mention_uids",
                mentioner_uids: "#{prefix}:mentioner_uids",
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
      Aji.redis.zadd @keys[:mention_uids], mention.created_at.to_i, "#{mention.uid} / #{mention.author.uid}"
      expire_keys
    end

    def mention_count mentioner=nil
      return (Aji.redis.zscore(@keys[:mentioner_uids], mentioner.uid)).to_i if mentioner
      Aji.redis.zcard @keys[:mention_uids]
    end

    def mentioner_count
      Aji.redis.zcard @keys[:mentioner_uids]
    end

    def spammer_count
      Aji.redis.zcard @keys[:spammer_uids]
    end

    def destroy
      expire_keys 0
    end

    def track_spam spam
      Aji.redis.zadd @keys[:spammer_uids], spam.created_at.to_i, spam.author.uid
      expire_keys
    end

    def acceptable_spammer_count
      2 + mentioner_count/30
    end

    def spammed_by_others?
      spammer_count > acceptable_spammer_count
    end

    def spam?
      not (Aji.redis.zscore Spam_Key, uid).nil?
    end

    def mark_spam
      Aji.redis.zadd Spam_Key, Time.now.to_i, uid
      puts "SPAM: #{self.to_s}"

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

      "#{@source}[#{@uid}], #{mention_count} mentions (TTL: #{Aji.redis.ttl @keys[:mention_uids]}) "+
      "by #{mentioner_count} authors (TTL: #{Aji.redis.ttl @keys[:mentioner_uids]}) (#{ages.join(', ')})"+
      ", #{spammer_count} spammers (TTL: #{Aji.redis.ttl @keys[:spammer_uids]})"
    end

    def expire_keys ttl=6.hours
      @keys.each_pair do |name, key|
        Aji.redis.expire key, ttl
      end
    end

    private :expire_keys
  end
end