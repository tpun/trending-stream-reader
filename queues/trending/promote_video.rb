module Queues
  module Trending
    class PromoteVideo
      @queue = :mention

      def self.perform tweet
        mention = ::Mention.new tweet
        return if mention.spam?

        trending = ::Trending.new
        trending.promote_video mention.video, mention.significance
      end
    end
  end
end
