# Rakefile for the NOWBOX StreamReader.

task :environment do
  config_file = "./config.yml"
  @settings = if File.exists? config_file
                YAML.decode File.read "./config.yml"
              else
                ENV
              end
end

task :read => :environment do
  require './lib/stream_reader'

  stream_reader = StreamReader.new(
    @settings['CONSUMER_KEY'],
    @settings['CONSUMER_SECRET'],
    @settings['OAUTH_TOKEN'],
    @settings['OAUTH_SECRET']
  )

  stream_reader.start
end
