require 'rspec'
require 'pry'
require 'redis'
require 'resque'
require 'resque_scheduler'
require 'active_support/core_ext/object'
require 'logger'
require 'yaml'

require_relative 'lib/stream_reader'
Dir.glob("models/*.rb").each { |r| require_relative r }
Dir.glob("queues/*.rb").each { |r| require_relative r }
Dir.glob("queues/mention/*.rb").each { |r| require_relative r }
Dir.glob("queues/trending/*.rb").each { |r| require_relative r }

module Aji
  def Aji.settings
    unless @settings
      @settings = {}.tap do |setting|
        setting_file = "./config/settings.yml"
        resque_schedule_file = "./config/resque_schedule.yml"
        if File.exists? setting_file
          setting.merge! YAML.load_file(setting_file)
          setting['RESQUE_SCHEDULE'] = YAML.load_file resque_schedule_file
        else
          setting.merge! ENV
        end
      end
    end
    @settings
  end

  def Aji.redis
    uri = URI Aji.settings['REDISTOGO_URL']
    @redis ||= Redis.new( host: uri.host,
                          port: uri.port,
                          password: uri.password,
                          db: uri.path[1..-1] )
  end
  Resque.redis = Aji.redis
  Resque.schedule = Aji.settings['RESQUE_SCHEDULE']

  RSpec.configure do |config|
    config.before :each do
      Aji.redis.flushdb
    end
  end

  def Aji.log
    if @logger.nil?
      @logger = ::Logger.new STDERR
      @logger.level = ::Logger::DEBUG
    end
    @logger
  end
end

