require 'spec_helper'

describe CrossoverAgent do
  let(:crossover_agent) {
    CrossoverAgent::Base.new
  }
  let(:config) {
    config = YAML.load_file(File.dirname(__FILE__) + '/fixtures/sample-config.yml')
  }
  it 'has a version number' do
    expect(CrossoverAgent::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(crossover_agent.say_hello).to eq("Hello World")
  end

  it 'read from config file' do
    expect(crossover_agent.server).to eq(config['server'])
  end

  it 'post to server' do
    data = {
        cpu_usage: '10%',
        disk_usage: '20%',
        running_processes: []
    }
    expect(RestClient).to receive(:post).with(crossover_agent.remote_url, data.to_json, {content_type: :json, accept: :json})
    crossover_agent.push_data
  end
end
