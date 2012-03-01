module Aji
  class Video
    attr_reader :uid, :source, :keys
    def initialize uid, source='youtube'
      @uid = uid
      @source = source
      @keys = { mention_uids:   "video:#{@source}[#{@uid}]:mention_uids",
                mentioner_uids: "video:#{@source}[#{@uid}]:mentioner_uids" }
    end

    def spammed_by? mentioner
      mention_count(mentioner) > 2
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

    def to_s
      ages = []
      Aji.redis.zrevrange(@keys[:mention_uids], 0, 5).each do |mid|
        time = (Aji.redis.zscore @keys[:mention_uids], mid).to_i
        ages << (Time.now.to_i - time)
      end
      "#{@source}[#{@uid}], #{mention_count} mentions (#{ages.join(', ')})"
    end

    # Because we remove everything that doesn't get another mention in 2 hours
    # we only need the video keys to live for that long
    def expire_keys ttl=125.minutes
      @keys.each_pair do |name, key|
        Aji.redis.expire key, ttl
      end
    end

    private :expire_keys
  end
end