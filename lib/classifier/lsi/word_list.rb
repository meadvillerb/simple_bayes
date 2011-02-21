# Author::    David Fayram  (mailto:dfayram@lensmen.net)
# Copyright:: Copyright (c) 2005 David Fayram II
# License::   LGPL

module Classifier  
  # This class keeps a word => index mapping. It is used to map stemmed words
  # to dimensions of a vector.
  
  class WordList
    def initialize( lsi )
      @lsi = lsi
    end
    
    # List all categories in the database.
    def categories
      db[:categories].all.map { |c| c[:name] }.sort
    end
    
    # List all words in the database.
    def words
      db[:words].all.map { |w| w[:stem] }.sort
    end
    
    # Returns the dimension of the word or nil if the word is not in the space.
    def [](word)
      db[:words].filter(:stem => word).first[:id] - 1 if includes?(word)
    end
    
    def word_for_index(dimension)
      if dimension + 1 < word_count
        db[:words].filter(:id => dimension + 1).first[:stem]
      end
    end
    
    def includes?(word)
      db[:words].filter(:stem => word).count > 0
    end
    
    # Remove any words that appear in every document.
    def remove_common_words
      # TODO
    end
    
    # Count the number of words in the database.
    def word_count
      db[:words].count
    end
    alias :size :word_count
    
    private
    
    def db
      @lsi.db
    end
  end
  
end
