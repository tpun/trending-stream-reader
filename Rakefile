require 'resque/tasks'
require 'resque_scheduler/tasks'

task :environment do
  require_relative 'app.rb'
end

task "resque:setup" => :environment

task :readstream => :environment do
  stream_reader = Aji::StreamReader.new(
    Aji.settings['CONSUMER_KEY'],
    Aji.settings['CONSUMER_SECRET'],
    Aji.settings['OAUTH_TOKEN'],
    Aji.settings['OAUTH_SECRET'],
    Aji::Queues::Trending::PromoteVideo
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