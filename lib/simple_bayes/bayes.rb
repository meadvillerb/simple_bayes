# encoding: utf-8

# Author::    Zeke Templin
#             Ian D. Eccles
#             Lucas Carlson  (mailto:lucas@rufy.com)
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

      @word_totals = Hash.new { |h,k| h[k] = 0 }
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
        @word_totals[word] += count
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
          @word_totals[word] -= count
          if @categories[category][word] <= 0
            @categories[category].delete(word)
            count = orig
          end
          @total_words -= count
        end
      end
    end
    
    
    # Calculates how the text scores for each category.  For each category
    # we calculate the score of each word as follows:
    #
    #   P(B|A) = (occurrences of word in category) / (word count of category)
    #   P(A)   = (word count of category) / (total word count)
    #   P(B)   = (total occurrences of word) / (total word count)
    # Then,
    #
    #   P(A|B) = P(B|A) * P(A) / P(B)
    #
    # We simplify by factoring out repeated terms and arrive at:
    #
    #   P(A|B) = (occurences of word in category) / (total word count)
    #
    # Finally, we sum all of these P(A|B) values and divide by the total
    # number of unique words in the given text, thus producing a value in
    # [0, 1].
    #
    # This may be wrong, as it seems almost too simple, but at least it's
    # spelled out how we're arriving at our scores.
    def classifications text
      score = {}
      @categories.each do |category, category_words|
        score[category.to_s] = 0
        unique_words = 0
        WordHash.new(text).each do |word, count|
          unique_words += 1
          word_total = @word_totals[word].to_f
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
      classifications(text).inject([nil, -1]) do |max, cs_pair|
        max.last > cs_pair.last ? max : cs_pair
      end.first
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
