# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'simple_bayes/version'

Gem::Specification.new do |s|
  s.name         = "simple_bayes"
  s.version      = SimpleBayes::VERSION
  s.authors      = ["Ezekiel Templin", "Lucas Carlson"]
  s.email        = "ezkl@me.com"
  s.homepage     = "http://github.com/ezkl/simple_bayes"
  s.summary      = "Bayesian and LSI classification in Ruby."
  s.description  = "Classifier is a general module to allow Bayesian and other types of classifications. Forked at nragaz/classifier from cardmagic/classifier."

  s.files        = `git ls-files lib`.split("\n")
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'

  s.add_dependency('ruby-stemmer', '>= 0.9.1')
  s.requirements << "A stemmer module to split word stems."
end
