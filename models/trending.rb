module Aji
  class Trending
    def initialize video_source='youtube'
      @video_source = video_source
    end

    def key
      "trending::#{@video_source}"
    end

    def promote_video mention
      Aji.redis.zincrby key, mention.significance, mention.video.uid
    end
  end
end