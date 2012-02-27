module Aji
  module Queues
    module Trending
      class Refresh
        @queue = :trending

        def self.perform args
          puts "refreshed"
        end
      end
    end
  end
end