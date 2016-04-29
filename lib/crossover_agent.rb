require "crossover_agent/version"
require 'ostruct'
require 'rest-client'
require 'json'
module CrossoverAgent
  class Base
    attr_reader :server, :port
    def initialize(&block)
      @config = OpenStruct.new(:server => 'localhost', :port => '8090')
      yield @config if block_given?
      @server = @config.server
      @port = @config.port
    end

    def say_hello
      "Hello World"
    end

    def remote_url
      "http://#{@server}:#{@port}/metrics"
    end

    protected
    def push_data
      RestClient.post remote_url, collect_data.to_json, :content_type => :json, :accept => :json
    end

    def collect_data
      data = {
          cpu_usage: '10%',
          disk_usage: '20%',
          running_processes: []
      }
    end
  end
end
