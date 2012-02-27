require 'resque/tasks'
require 'resque_scheduler/tasks'

task :environment do
  require 'pry'
  require 'redis'
  require 'resque'
  require 'resque_scheduler'

  require_relative 'lib/stream_reader'
  Dir.glob("models/*.rb").each { |r| require_relative r }
  Dir.glob("queues/*.rb").each { |r| require_relative r }
  Dir.glob("queues/mention/*.rb").each { |r| require_relative r }
  Dir.glob("queues/trending/*.rb").each { |r| require_relative r }

  config_file = "./config.json"
  @settings = if File.exists? config_file
                 Yajl::Parser.parse File.read config_file
              else
                ENV
              end
  uri = URI @settings['REDISTOGO_URL']
  @redis = Redis.new(
    host: uri.host,
    port: uri.port,
    password: uri.password,
    db: uri.path[1..-1])
  Resque.redis = @redis
end

task "resque:setup" => :environment

task :readstream => :environment do
  stream_reader = StreamReader.new(
    @settings['CONSUMER_KEY'],
    @settings['CONSUMER_SECRET'],
    @settings['OAUTH_TOKEN'],
    @settings['OAUTH_SECRET'],
    Queues::Mention::Process
  )

  stream_reader.start
end

task :c => :console
task :console => :environment do
  Pry.start
end
