module Aji
  class Video
    attr_reader :uid, :source
    def initialize uid, source='youtube'
      @uid = uid
      @source = source
    end

    def key # uids of mentioners
      @key ||= "video:#{@source}[#{@uid}]:mentioner_uids"
    end

    def spammed_by? mentioner_uid
      mention_count(mentioner_uid) > 2
    end

    def mentioned mentioner_uid
      Aji.redis.zincrby key, 1, mentioner_uid
      Aji.redis.expire key, 6.hours
    end

    def mention_count mentioner_uid
      (Aji.redis.zscore(key, mentioner_uid)).to_i
    end
  end
end