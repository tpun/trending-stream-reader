module Aji
  module Queues
    module Trending
      class Refresh
        @queue = :trending

        def self.perform
          trending = Aji::Trending.new 'youtube'
          trending.refresh
        end
      end
    end
  end
end