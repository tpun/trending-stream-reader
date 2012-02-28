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
      "#{@source}[#{@uid}], #{mention_count} mentions ()"
    end

    def expire_keys ttl=6.hours
      @keys.each_pair do |name, key|
        Aji.redis.expire key, ttl
      end
    end

    private :expire_keys
  end
end