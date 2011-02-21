# Author::    David Fayram  (mailto:dfayram@lensmen.net)
# Copyright:: Copyright (c) 2005 David Fayram II
# License::   LGPL

module Classifier
  class LSI
    
    # This is an internal data structure class for the LSI node. Save for 
    # raw_vector_with, it should be fairly straightforward to understand.
    # You should never have to use it directly.
    class ContentNode
      attr_accessor :raw_vector, :raw_norm, :lsi_vector, :lsi_norm
      
      attr_reader :word_hash, :lsi, :id
      
      # Options:
      #  - key (unique identifier)
      #  - categories (array)
      def initialize( lsi, source, options={} )
        @lsi = lsi
        
        self.content = source.to_s
        self.retrieval_key = options[:key]
        self.categories = options[:categories] || []
        
        WordHash.new(source).each do |word, frequency|
          word_id = (word = db[:words].filter(:stem => word).first) ?
            word.id : db[:words].insert(:stem => word)
            
          db[:word_lists].insert(
            :content_node_id => self.id,
            :frequency => frequency
          )
        end
      end
      
      # Select all categories for this model
      def categories
        db[:categories_content_nodes].
          filter(:content_node_id => self.id).
          join(:categories, :id => :category_id)
      end
      
      # Use this to fetch the appropriate search vector.
      def search_vector
        @lsi_vector || @raw_vector
      end
      
      # Use this to fetch the appropriate search vector in normalized form.
      def search_norm
        @lsi_norm || @raw_norm
      end
      
      # Creates the raw vector out of word_hash using word_list as the
      # key for mapping the vector space.
      def raw_vector_with( word_list=nil )
        word_list = Word.all
        
        vec = $GSL ?
          GSL::Vector.alloc(Word.count) :
          Array.new(Word.count, 0)
        
        @word_hash.each_key do |word|
          vec[word_list[word]] = @word_hash[word] if word_list[word]
        end
        
        # Perform the scaling transform
        total_words = vec.sum
        
        # Perform first-order association transform if this vector has more
        # than one word in it. 
        if total_words > 1.0
          weighted_t = 0.0
          vec.select { |t| t > 0 }.each do |term|
            weighted_t += (term / total_words) * Math.log(term / total_words)
          end
          vec = vec.collect { |val| Math.log( val + 1 ) / -weighted_t }
        end
        
        if $GSL
          @raw_norm   = vec.normalize
          @raw_vector = vec
        else
          @raw_norm   = Vector[*vec].normalize
          @raw_vector = Vector[*vec]
        end
      end
      
      private
      
      def db
        @lsi.db
      end
    end
    
  end
end