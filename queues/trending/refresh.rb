module Aji
  module Queues
    module Trending
      class Refresh
        @queue = :trending

        def self.perform video_source
          start = Time.now

          trending = Aji::Trending.new video_source
          Aji.log.info "Refreshing #{trending} with #{trending.video_uids.count} videos..."
          trending.refresh
          Aji.log.info "Done refreshing in #{Time.now-start} s"
          trending.print
        end
      end
    end
  end
end