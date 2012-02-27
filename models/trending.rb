module Aji
  class Trending
    def initialize video_source='youtube'
      @video_source = video_source
    end

    def key
      "trending::#{@video_source}"
    end

    def promote_video video_external_id, significance
      Aji.redis.zincrby key, significance, video_external_id
    end
  end
end