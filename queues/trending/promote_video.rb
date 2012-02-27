module Aji
  module Queues
    module Trending
      class PromoteVideo
        @queue = :mention

        def self.perform tweet
          mention = Aji::Mention.new tweet
          return if mention.spam?

          trending = Aji::Trending.new
          trending.promote_video mention.video.external_id, mention.significance
        end
      end
    end
  end
end