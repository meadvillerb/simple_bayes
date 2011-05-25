# encoding: utf-8

# Author::    Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

module SimpleBayes
  class << self
    def new(*categories)
      Bayes.new(categories)
    end
  end
  
  class Bayes
    
    # The class can be created with one or more categories, each of which will be
    # initialized and given a training method. E.g., 
    #      b = SimpleBayes::Bayes.new :interesting, :uninteresting
    def initialize(*categories)
      options = categories.pop if categories.last.is_a? Hash
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
  
    def classifications(text)
      score = Hash.new
      @categories.each do |category, category_words|
        score[category.to_s] = 0
        total = category_words.values.inject(0) {|sum, element| sum+element}
        WordHash.new(text).each do |word, count|
          s = category_words.has_key?(word) ? category_words[word] : 0.1
          # This is only (kind of) bayes if P(A) = P(B) = 1.0
          score[category.to_s] += Math.log(s/total.to_f)
        end
      end
      score
    end
    
    def classifications2 text
      score = {}
      @categories.each do |category, category_words|
        score[category.to_s] = 0
        cat_total = category_words.values.inject(0) { |sum, n| sum + n }.to_f
        # P(A), roughly
        cat_prob = cat_total / @total_words
        unique_words = 0
        WordHash.new(text).each do |word, count|
          # Increment for each unique word
          unique_words += 1
          # P(B), we'll want to pre-calculate some of this to save time
          word_total = @categories.inject(0) do |sum, (cat, cws)|
            sum + cws[word]
          end.to_f
          word_prob = word_total / @total_words
          # P(B|A)
          word_given_prob = category_words[word] / cat_total
          # And now, Bayes' Theorem: P(A|B) = P(B|A) * P(A) / P(B)
          score[category.to_s] += word_given_prob * cat_prob / word_prob
        end
        score.each do |cat, s|
          score[cat] = s / unique_words
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

    alias append_category add_category

  end
end
