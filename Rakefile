# Rakefile for the NOWBOX StreamReader.

task :environment do
  require './lib/stream_reader'
  require './lib/mention_queue'

  config_file = "./config.json"
  @settings = if File.exists? config_file
                 Yajl::Parser.parse File.read config_file
              else
                ENV
              end
end

task :read => :environment do
  mention_queue = MentionQueue.new(
    @settings['REDISTOGO_URL'],
    @settings['CHANNEL_ID']
  )

  stream_reader = StreamReader.new(
    @settings['CONSUMER_KEY'],
    @settings['CONSUMER_SECRET'],
    @settings['OAUTH_TOKEN'],
    @settings['OAUTH_SECRET'],
    mention_queue
  )

  stream_reader.start
end
