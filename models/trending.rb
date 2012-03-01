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
      decay_videos decay_percent

      # Usually if we don't get another mention within 2 hours,
      # it's probably not something we care.
      min_relevance = Mention::Relevance / 4
      truncate_videos min_relevance
    end

    def relevance video
      relevance_by_uid video.uid
    end

    def relevance_by_uid video_uid
      Aji.redis.zscore(@key, video_uid).to_i
    end

    def set_relevance_by_uid video_uid, new_relevance
      Aji.redis.zadd @key, new_relevance, video_uid
    end

    def decay_videos by_percent
      video_uids.each do |video_uid| # so we create video object one by one
        original = relevance_by_uid video_uid
        decayed = original * (100 - by_percent) / 100
        set_relevance_by_uid video_uid, decayed
      end
    end

    def remove_video video
      video.destroy
      Aji.redis.zrem @key, video.uid
    end

    def truncate_videos min_relevance
      old_uids = Aji.redis.zrangebyscore @key, "-inf", min_relevance
      old_uids.each do |vid|
        video = Video.new vid
        remove_video video
      end
      Aji.log.info "Destroyed #{old_uids.count} videos."
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