$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'crossover_agent'
require 'yaml'

RSpec.configure do |config|
  config.before(:each) do
    CrossoverAgent::Base.send(:public, *CrossoverAgent::Base.protected_instance_methods)
    CrossoverAgent::Base.send(:public, *CrossoverAgent::Base.private_instance_methods)
  end
end