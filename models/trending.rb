module Aji
  class Trending
    attr_reader :video_source, :key
    def initialize video_source='youtube'
      @video_source = video_source
      @key = "trending::#{@video_source}"
    end

    def promote_video video, by_relevance
      Aji.redis.zincrby @key, by_relevance, video.uid
    end

    def video_uids limit=0
      Aji.redis.zrevrange @key, 0, (limit-1)
    end

    def videos limit=0
      video_uids(limit).map { |vid| Video.new vid, @video_source }
    end

    def refresh
      # We want 1 mention to have effect over 4 hours.
      # 10,000 is default for 1 mention and we refresh 4 times an hour.
      # 15% geometric decay will be close to having a half life of 1 hour.
      decay_percent = 15

      # Usually if we don't get another mention within 2 hours,
      # it's probably not something we care.
      min_relevance = Mention::Relevance / 4

      decay_videos decay_percent
      truncate_videos min_relevance
    end

    def relevance video
      Aji.redis.zscore(@key, video.uid).to_i
    end

    def set_relevance video, new_relevance
      Aji.redis.zadd @key, new_relevance, video.uid
    end

    def decay_videos by_percent
      video_uids.each do |vid| # so we create video object one by one
        video = Video.new vid, @video_source
        original = relevance video
        decayed = original * (100 - by_percent) / 100
        set_relevance video, decayed
      end
    end

    def truncate_videos min_relevance
      Aji.redis.zremrangebyscore @key, "-inf", min_relevance
    end

    def print top=10
      Aji.log.debug "Trending on #{@video_source}, #{video_uids.count} videos:"
      top_videos = video_uids(top).each do |vid|
        video = Video.new vid, @video_source
        Aji.log.debug "  #{relevance(video).to_s.rjust(5)} | #{video.to_s}"
      end
    end
  end
end