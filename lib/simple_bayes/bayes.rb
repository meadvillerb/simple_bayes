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

      categories.each do |category|
        @categories[category] = Hash.new { |h,k| h[k] = 0 }
      end

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
          @categories[category][word]      -=     count
          if @categories[category][word] <= 0
            @categories[category].delete(word)
            count = orig
          end
          @total_words -= count
        end
      end
    end
    
    def classifications text
      score = {}
      @categories.each do |category, category_words|
        score[category.to_s] = 0
        unique_words = 0
        WordHash.new(text).each do |word, count|
          # Increment for each unique word
          unique_words += 1
          # P(B), we'll want to pre-calculate some of this to save time
          word_total = @categories.inject(0) do |sum, (cat, cws)|
            sum + cws[word]
          end.to_f
          # And now, Bayes' Theorem: P(A|B) = P(B|A) * P(A) / P(B), but
          # we get a lot of simplifications in the end.... sweet!
          if word_total > 0
            word_score = (category_words[word] / word_total)
            score[category.to_s] += word_score
          end
        end
        if unique_words > 0
          score[category.to_s] /= unique_words
        end
      end
      score
    end

    def classify(text)
      puts classifications(text)
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
