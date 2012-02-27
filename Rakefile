require 'resque/tasks'
require 'resque_scheduler/tasks'

task :environment do
  require_relative 'app.rb'
end

task "resque:setup" => :environment

task :readstream => :environment do
  stream_reader = StreamReader.new(
    @settings['CONSUMER_KEY'],
    @settings['CONSUMER_SECRET'],
    @settings['OAUTH_TOKEN'],
    @settings['OAUTH_SECRET'],
    Queues::Trending::PromoteVideo
  )

  stream_reader.start
end

task :c => :console
task :console => :environment do
  Pry.start
end

task :spec => :environment do
  system "rspec spec"
end