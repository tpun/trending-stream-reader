module Queues
  module Mention
    class Process
      @queue = :mention

      def self.perform tweet
        puts "processing: #{tweet}"
      end

    end
  end
end
