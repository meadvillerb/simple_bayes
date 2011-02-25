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
    
    def update_dimensions
      i = 0
      db[:words].all.each do |word|
        db[:words].where(:id => word[:id]).update(:dimension => i)
        i += 1
      end
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
      db[:words].filter(:stem => word).first[:dimension] if includes?(word)
    end
    
    def word_for_index(dimension)
      word = db[:words].filter(:dimension => dimension).first
      word ? word[:stem] : nil
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
