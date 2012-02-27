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

    def spammed_by? mentioner
      mention_count(mentioner) > 2
    end

    def mentioned_by mentioner
      Aji.redis.zincrby key, 1, mentioner.uid
      Aji.redis.expire key, 6.hours
    end

    def mention_count mentioner
      (Aji.redis.zscore(key, mentioner.uid)).to_i
    end
  end
end