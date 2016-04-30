require "crossover_agent/version"
require 'ostruct'
require 'rest-client'
require 'json'
require 'yaml'
require 'usagewatch_ext'
require 'cli-parser'
module CrossoverAgent
  class Base
    attr_reader :server, :port, :auth_token, :ec2_instance_id
    def initialize(&block)
      @config = OpenStruct.new(server: 'localhost', port: '3000', auth_token: '123456')
      yield @config
      @server = @config['server']
      @port = @config['port']
      @auth_token = @config['auth_token']
      @limit = @config['limit'] || 10
      @delay = @config['delay'] || 1
      @ec2_instance_id = `wget -q -O - http://instance-data/latest/meta-data/instance-id`
      @ec2_instance_id = "localhost" if @ec2_instance_id.empty?
      @usg = Usagewatch
    end

    def remote_url
      "http://#{@server}:#{@port}/metrics"
    end

    def self.execute
      cli_options = %w(-s -p -t -l -d)
      args, options = CliParser.parse([], cli_options)
      agent = CrossoverAgent::Base.new do |cfg|
        cfg.server = options['-s'] if options['-s']
        cfg.port = options['-p'] if options['-p']
        cfg.auth_token = options['-t'] if options['-t']
        cfg.limit = options['-l'].to_i if options['-l']
        cfg.delay = options['-d'].to_i if options['-d']
      end
      agent.execute
    end
    def execute

      loop do
        begin
          push_data
        rescue Exception => e
          puts e.message
        ensure
          sleep @delay
        end
      end
    end
    protected
    def push_data
      RestClient.post remote_url, collect_data.to_json, :content_type => :json, :accept => :json
    end

    def collect_data
      cpu_usage = @usg.uw_cpuused
      disk_usage = @usg.uw_diskused
      running_processes = get_processes(@limit)
      data = {
        metric: {
          cpu_usage: cpu_usage,
          disk_usage: disk_usage,
          running_processes: running_processes,
          auth_token: @auth_token,
          ec2_instance_id: @ec2_instance_id
        }
      }
    end

    def get_processes(limit)
      ps = `ps aux`
      mapping = [:user, :pid, :cpu, :mem, :vsz, :rss, :tt, :stat, :started, :time, :command, :arg]

      res = []
      arr = ps.split("\n")[2..limit]
      arr.each do |item|
        tmp = {}
        x = item.split(" ")
        x.each_with_index do |i, ind|
          tmp[mapping[ind]] = i
        end
        res << tmp
      end
      res
    end
  end


end
