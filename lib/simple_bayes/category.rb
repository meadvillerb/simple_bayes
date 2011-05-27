# encoding: utf-8

# Author::    Ian D. Eccles
# Copyright:: Copyright (c) 2011 Ian D. Ecles
# License::   LGPL

module SimpleBayes
  # Categories are going to be a shared idea, so why not break out the
  # common category functionality into its own class.
  class Category
    include TermOccurrence
    
    attr_reader :name, :term_occurrences
    
    def initialize name
      @name = name
      @term_occurrences = Hash.new 0
    end
    
    def log_probability classifier
      uniqs = classifier.total_unique.to_f
      cat_uniqs = total_unique
      if uniqs > 0 && cat_uniqs > 0
        Math.log(cat_uniqs) - Math.log(uniqs)
      else
        -Float::MAX
      end
    end
    
    def probability classifier
      Math.exp log_probability(classifier)
    end
    
    # Calculates the probability of a document given this category, ie:
    #
    #     P(D|C) = \prod_i P(T_i | C)
    #            = \prod_i (occurrences of T_i in C) / (occurrences of all terms in C)
    #
    # Uses a default probability of 0.05 for a term that does not occur at all
    # in this category.
    # @param [WordHash] doc
    def probability_of_document doc, default_prob = 0.05
      Math.exp log_probability_of_document(doc, default_prob)
    end
    
    def log_probability_of_document doc, default_prob = 0.05
      all_occurs = total_occurrences.to_f
      return -Float::MAX if all_occurs < 1

      doc.inject(0) do |sum, (t,_)|
        t_occurs = occurrences_of(t)
        log_prob_t = (t_occurs > 0 ? (Math.log(t_occurs) - Math.log(all_occurs)) : Math.log(default_prob) )
        sum + log_prob_t
      end
    end
  end
end
