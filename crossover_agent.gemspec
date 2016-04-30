# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crossover_agent/version'

Gem::Specification.new do |spec|
  spec.name          = "crossover_agent"
  spec.version       = CrossoverAgent::VERSION
  spec.authors       = ["Truong Hoang Dung"]
  spec.email         = ["checkraiser11@gmail.com"]

  spec.summary       = %q{Basic Agent for CrossOver Monitoring Server}
  spec.description   = %q{Basic Agent for CrossOver Monitoring Server}
  spec.homepage      = "https://github.com/checkraiser/crossover_agent"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ["crossover_agent"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency             "rest-client"
  spec.add_dependency             "cpu"
  spec.add_dependency             "sys-filesystem"
  spec.add_dependency             "cli-parser"
end
