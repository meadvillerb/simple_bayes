# encoding: utf-8

# Author::    Zeke Templin
#             Ian D. Eccles
#             Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

module SimpleBayes  
  class Bayes
    include Categorical
    include TermOccurrence
    
    attr_reader :categories, :term_occurrences
    
    # The class can be created with one or more categories, each of which will be
    # initialized and given a training method. E.g., 
    #      b = SimpleBayes::Bayes.new :interesting, :uninteresting
    def initialize(*categories)
      @categories = {}
      @term_occurrences = Hash.new 0
      create_categories categories
    end

    #
    # Provides a general training method for all categories specified in Bayes#new
    # For example:
    #     b = SimpleBayes::Bayes.new :this, :that, :the_other
    #     b.train :this, "This text"
    #     b.train :that, "That text"
    #     b.train :the_other, "The other text"
    def train(name, text)
      doc = Document.new text
      store_document doc
      category(name).store_document doc
    end

    #
    # Provides a untraining method for all categories specified in Bayes#new
    # Be very careful with this method.
    #
    # For example:
    #     b = SimpleBayes::Bayes.new :this, :that, :the_other
    #     b.train :this, "This text"
    #     b.untrain :this, "This text"
    def untrain(name, text)
      doc = Document.new text
      remove_document doc
      category(name).remove_document doc
    end

    def classifications text, default_prob = 0.005
      doc = Document.new text
      categories.values.map do |cat|
        prob_cat = cat.probability self
        prob_doc = cat.probability_of_document(doc, default_prob)
        [prob_cat * prob_doc, cat]
      end
    end
    
    def log_classifications text, default_prob = 0.005
      doc = Document.new text
      categories.values.map do |cat|
        prob_cat = cat.log_probability self
        prob_doc = cat.log_probability_of_document(doc, default_prob)
        [prob_cat + prob_doc, cat]
      end
    end

    def classify text
      log_classifications(text).inject([-Float::MAX, nil]) do |max, cs_pair|
        max.first > cs_pair.first ? max : cs_pair
      end.last.name
    end
  end
end
