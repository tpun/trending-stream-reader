require 'yajl'
require 'tweetstream'

module Aji
  class StreamReader
    def initialize consumer_key, consumer_secret, token, token_secret, queue_class
      TweetStream.configure do |c|
        c.consumer_key = consumer_key
        c.consumer_secret = consumer_secret
        c.oauth_token = token
        c.oauth_token_secret = token_secret
        c.auth_method = :oauth
        c.parser = :yajl
      end

      @keywords = ['youtube http']
      @queue_class = queue_class
      @client = TweetStream::Client.new

      set_limit
      set_error
      set_delete
    end

    # What to do when receiving a limit message. No action is needed since they
    # regulate us on their end. We just log how many we missed.
    def set_limit
      @client.on_limit do |tweets_skipped|
        Aji.log.info "Missed #{tweets_skipped} due to rate limiting."
      end
    end

    # What to do when an error occurs. For now we just log it.
    def set_error
      @client.on_error do |message|
        Aji.log.error "ERROR: #{message}"
      end
    end

    # What to do when a tweet is deleted. In the future we will need to have a
    # queue to delete mentions. Twitter expects us to honor deletion requests in a
    # timely manner and if we don't then somehow bad things?
    def set_delete
      @client.on_delete do |status_id, user_id|
        Aji.log.debug "App should delete status:#{status_id} from user:#{user_id}"
      end
    end

    # Start tracking links specifically youtube links if available. If a block is
    # given, processing will be delegated to that block otherwise the tweet will
    # be printed to the log.
    def start
      count = 0
      @client.track(@keywords) do |tweet|
        Resque.enqueue @queue_class, tweet
        count +=1
        Aji.log.info "Enqueued #{count} tweets" if count % 1000 == 0
      end
    end
  end
end