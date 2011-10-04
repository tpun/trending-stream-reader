# Rakefile for the NOWBOX StreamReader.

task :environment do
  config_file = "./config.json"

  require './lib/stream_reader'

  @settings = if File.exists? config_file
                 Yajl::Parser.parse File.read config_file
              else
                ENV
              end
end

task :read => :environment do
  p @settings

  stream_reader = StreamReader.new(
    @settings['CONSUMER_KEY'],
    @settings['CONSUMER_SECRET'],
    @settings['OAUTH_TOKEN'],
    @settings['OAUTH_SECRET']
  )

  stream_reader.start
end
