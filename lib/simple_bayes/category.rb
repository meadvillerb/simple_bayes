# encoding: utf-8

# Author::    Ian D. Eccles
# Copyright:: Copyright (c) 2011 Ian D. Ecles
# License::   LGPL

module SimpleBayes
  # Categories are going to be a shared idea, so why not break out the
  # common category functionality into its own class.
  class Category
    MIN_LOG_PROBABILITY = -Float::MAX
    include TermOccurrence
    
    attr_reader :name, :term_occurrences
    
    def initialize name
      @name = name
      @term_occurrences = Hash.new 0
    end
    
    def log_probability uniqs
      tot = total_unique
      (uniqs > 0 && tot > 0) ? Math.log(tot/uniqs) : MIN_LOG_PROBABILITY
    end
    
    def probability uniqs
      Math.exp log_probability(uniqs)
    end
    
    # Calculates the probability of a document given this category, ie:
    #
    #     P(D|C) = \prod_i P(T_i | C)
    #            = \prod_i (occurrences of T_i in C) / (occurrences of all terms in C)
    #
    # Uses a default probability of 0.005 for a term that does not occur at all
    # in this category.
    # @param [WordHash] doc
    def probability_of_document doc, default_prob = 0.005
      Math.exp log_probability_of_document(doc, default_prob)
    end
    
    def log_probability_of_document doc, default_prob = 0.005
      all = total_occurrences.to_f
      return MIN_LOG_PROBABILITY if all < 1

      doc.inject(0) do |sum, (t,_)|
        term = occurrences_of(t)
        sum + Math.log(term > 0 ? term/all : default_prob)
      end
    end
  end
end
