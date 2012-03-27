module Aji
  module Queues
    module Trending
      class PromoteVideo
        @queue = :mention

        def self.perform raw_tweet
          # Ignore invalid tweet
          catch(:invalid_raw) do
            mention = Aji::Mention.new raw_tweet
            if mention.spam? or !mention.english?
              mention.mark_spam
              return
            end

            trending = Aji::Trending.new mention.video.source
            trending.promote_video mention.video, mention.relevance
          end
        end
      end
    end
  end
end