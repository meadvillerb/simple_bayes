# encoding: utf-8

# Author::    Ian D. Eccles
# Copyright:: Copyright (c) 2011 Ian D. Ecles
# License::   LGPL

module SimpleBayes
  # Categories are going to be a shared idea, so why not break out the
  # common category functionality into its own class.
  class Category
    attr_reader :name, :term_frequencies
    
    def initialize name
      @name = name
      @term_frequencies = Hash.new 0
    end
    
    def train doc
      doc.inject(0) do |sum, (word, count)|
        store word, count
        sum + count
      end
    end
    
    def untrain doc
      doc.inject(0) do |sum, (word, count)|
        sum + remove(word, count)
      end
    end
    
    def store term, count=1
      term_frequencies[term] += count
    end
    
    def remove term, count=nil
      if term_frequencies.key? term
        cur = term_frequencies[term]
        count ||= cur
        (count < cur ? count : cur).tap do |decr|
          term_frequencies[term] -= decr
          term_frequencies.delete(term) if term_frequencies[term] == 0
        end
      else
        0
      end
    end
    
    def log_probability classifier
      uniqs = classifier.count_unique_terms.to_f
      cat_uniqs = count_unique_terms
      if uniqs > 0 && cat_uniqs > 0
        Math.log(cat_uniqs) - Math.log(uniqs)
      else
        0
      end
    end
    
    def probability classifier
      uniqs = classifier.count_unique_terms.to_f
      cat_uniqs = count_unique_terms
      if uniqs > 0 && cat_uniqs > 0
        cat_uniqs / uniqs
      else
        0
      end
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
      all_occurs = count_terms.to_f
      return 0.0 if all_occurs < 1

      doc.inject(1) do |prod, (t,_)|
        t_occurs = count_term(t)
        prob_t = (t_occurs > 0 ? (t_occurs / all_occurs) : default_prob )
        prod * prob_t
      end
    end
    
    def log_probability_of_document doc, default_prob = 0.05
      all_occurs = count_terms.to_f
      return -Float::MAX if all_occurs < 1

      doc.inject(0) do |sum, (t,_)|
        t_occurs = count_term(t)
        log_prob_t = (t_occurs > 0 ? (Math.log(t_occurs) - Math.log(all_occurs)) : Math.log(default_prob) )
        sum + log_prob_t
      end
    end
    
    def count_term term
      if term_frequencies.key? term
        term_frequencies[term]
      else
        0
      end
    end
    
    def count_unique_terms
      term_frequencies.select { |t,c| c > 0 }.size
    end
    
    def count_terms
      term_frequencies.inject(0) { |sum, (t,c)| sum + c }
    end
  end
end
