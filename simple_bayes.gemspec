# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'simple_bayes/version'

Gem::Specification.new do |s|
  s.name          = "simple_bayes"
  s.version       = SimpleBayes::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Lucas Carlson", "Ezekiel Templin", "Nick Ragaz", "Leo Soto", "Kyle Goodwin"]
  s.email         = "ezkl@me.com"
  s.homepage      = "https://github.com/ezkl/simple_bayes"
  s.summary       = "A Bayes-centric, slim fork of Lucas Carlson's classifier library."
  s.description   = "A Bayes-centric, slim fork of Lucas Carlson's classifier library including work from Nick Ragaz, Leo Soto, and Kyle Goodwin."

  s.files         = `git ls-files lib`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]
  
  s.required_ruby_version = ">= 1.9.2"
  
  s.add_dependency('ruby-stemmer', '>= 0.9.1')
  s.add_development_dependency("rspec", "~> 2.6.0")
  s.add_development_dependency("simplecov", "~> 0.4.2")  
end
