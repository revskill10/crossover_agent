require 'spec_helper'

describe CrossoverAgent do

  let(:crossover_agent) {
    CrossoverAgent::Base.new
  }

  it 'has a version number' do
    expect(CrossoverAgent::VERSION).not_to be nil
  end

  it 'post to server' do
    expect(RestClient).to receive(:post).with(crossover_agent.remote_url, kind_of(String), {content_type: :json, accept: :json})
    crossover_agent.push_data
  end
end
