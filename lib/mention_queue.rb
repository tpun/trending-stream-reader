require 'hiredis'
require 'redis'
require 'resque'
require 'uri'

class MentionQueue
  def initialize redis_uri, channel_id
    Resque.redis = redis_from redis_uri
    @channel_id = channel_id
  end

  # Add the tweet directly to the resque queue bypassing the public API since it
  # checks that the constants are defined in the running context whereas this
  # does not.
  def enqueue tweet_hash
    puts "Enqueing #{tweet_hash.id}"
    args = [ 'twitter', tweet_hash, @channel_id ]
    Resque.push 'mention', class: 'Aji::Queues::Mention::Process', args: args
  end

  def redis_from uri
    uri = URI uri
    Redis.new(
      :host => uri.host,
      :port => uri.port,
      :password => uri.password,
      :db => uri.path[1..-1]
    )
  end
end
