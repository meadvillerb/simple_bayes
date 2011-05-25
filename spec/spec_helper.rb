require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_group 'Libraries', '/lib/'
end

require 'rspec'

require 'simple_bayes'
require 'simple_bayes/bayes'
require 'simple_bayes/word_hash'

include SimpleBayes