# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'simple_bayes/version'

Gem::Specification.new do |s|
  s.name         = "simple_bayes"
  s.version      = SimpleBayes::VERSION
  s.authors      = ["Lucas Carlson", "Ezekiel Templin", "Nick Ragaz", "Leo Soto", "Kyle Goodwin"]
  s.email        = "ezkl@me.com"
  s.homepage     = "http://github.com/ezkl/simple_bayes"
  s.summary      = "A Bayes-centric, slim fork of Lucas Carlson's classifier library."
  s.description  = "A Bayes-centric, slim fork of Lucas Carlson's classifier library including work from Nick Ragaz, Leo Soto, and Kyle Goodwin."

  s.files        = `git ls-files lib`.split("\n")
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'

  s.add_dependency('ruby-stemmer', '>= 0.9.1')
  s.requirements << "A stemmer module to split word stems."
end
