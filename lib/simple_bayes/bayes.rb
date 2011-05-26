# encoding: utf-8

# Author::    Zeke Templin
#             Ian D. Eccles
#             Lucas Carlson  (mailto:lucas@rufy.com)
# Copyright:: Copyright (c) 2005 Lucas Carlson
# License::   LGPL

module SimpleBayes  
  class Bayes
    include Classifier
    
    attr_reader :categories, :total_words
    
    # The class can be created with one or more categories, each of which will be
    # initialized and given a training method. E.g., 
    #      b = SimpleBayes::Bayes.new :interesting, :uninteresting
    def initialize(*categories)
      @categories = Hash.new
      @word_totals = Hash.new { |h,k| h[k] = 0 }
      @total_words = 0
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
      WordHash.new(text).each do |word, count|
        category(name).store(word, count)
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
    def untrain(name, text)
      WordHash.new(text).each do |word, count|
        if @total_words >= 0
          removed = category(name).remove(word, count)
          @word_totals[word] -= removed
          @total_words -= removed
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
      categories.values.map do |cat|
        score = 0
        unique_words = 0
        WordHash.new(text).each do |word, count|
          unique_words += 1
          word_total = @word_totals[word].to_f
          # And now, Bayes' Theorem: P(A|B) = P(B|A) * P(A) / P(B), but
          # we get a lot of simplifications in the end.... sweet!
          # This actually may be wrong, as P(A) should probably be:
          #   (# Unique Words in A) / (Total # of Unique Words)
          if word_total > 0
            word_score = cat.count(word) / word_total
            score += word_score
          end
        end
        if unique_words > 0
          score /= unique_words
        end
        [score, cat]
      end
    end

    def classify(text)
      classifications(text).inject([-1, nil]) do |max, cs_pair|
        max.first > cs_pair.first ? max : cs_pair
      end.last.name
    end
  end
end
