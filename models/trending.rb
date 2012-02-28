module Aji
  class Trending
    attr_reader :video_source, :key
    def initialize video_source='youtube'
      @video_source = video_source
      @key = "trending::#{@video_source}"
    end

    def promote_video mention
      Aji.redis.zincrby @key, mention.significance, mention.video.uid
    end

    def video_uids limit=0
      (Aji.redis.zrevrange @key, 0, (limit-1)).map(&:to_i)
    end

    def refresh
    end
  end
end