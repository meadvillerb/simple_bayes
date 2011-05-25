# encoding: utf-8

# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

module SimpleBayes  
  class Bayes
    attr_reader :categories, :total_words
    
    # The class can be created with one or more categories, each of which will be
    # initialized and given a training method. E.g., 
    #      b = SimpleBayes::Bayes.new :interesting, :uninteresting
    def initialize(*categories)
      @categories = Hash.new
      categories.each { |category| @categories[category] = Hash.new }      
      @total_words = 0
    end

    #
    # Provides a general training method for all categories specified in Bayes#new
    # For example:
    #     b = SimpleBayes::Bayes.new :this, :that, :the_other
    #     b.train :this, "This text"
    #     b.train :that, "That text"
    #     b.train :the_other, "The other text"
    def train(category, text)
      WordHash.new(text).each do |word, count|
        @categories[category][word] ||=     0
        @categories[category][word] +=     count
        @total_words += count
      end
    end

    #
    # Provides a untraining method for all categories specified in Bayes#new
    # Be very careful with this method.
    #
    # For example:
    #     b = SimpleBayes::Bayes.new :this, :that, :the_other
    #     b.train :this, "This text"
    #     b.untrain :this, "This text"
    def untrain(category, text)
      WordHash.new(text).each do |word, count|
        if @total_words >= 0
          orig = @categories[category][word]
          @categories[category][word]     ||=     0
          @categories[category][word]      -=     count
          if @categories[category][word] <= 0
            @categories[category].delete(word)
            count = orig
          end
          @total_words -= count
        end
      end
    end
  
    def classifications(text)
      score = Hash.new
      @categories.each do |category, category_words|
        score[category.to_s] = 0
        total = category_words.values.inject(0) {|sum, element| sum+element}
        WordHash.new(text).each do |word, count|
          s = category_words.has_key?(word) ? category_words[word] : 0.1
          score[category.to_s] += Math.log(s/total.to_f)
        end
      end
      score
    end

    def classify(text)
      (classifications(text).sort_by { |a| -a[1] })[0][0]
    end

    def categories # :nodoc:
      @categories.keys.collect {|c| c }
    end

    def add_category(category)
      @categories[category] = Hash.new
    end
    
    def remove_category(category)
      @categories.delete(category)
    end
    
  end
end
