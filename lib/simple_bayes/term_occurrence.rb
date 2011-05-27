# encoding: utf-8

# Author::    Ian D. Eccles
# Copyright:: Copyright (c) 2011 Ian D. Ecles
# License::   LGPL

module SimpleBayes
  # Includers must define +term_occurrences+ method that returns a hash
  # keyed by terms and with each value corresponding to the 
  module TermOccurrence
    def store_document doc
      doc.each do |term, count|
        store_term term, count
      end
    end
    
    def remove_document doc
      doc.each do |term, count|
        remove_term term, count
      end
    end
    
    def store_term term, count=1
      term_occurrences[term] ||= 0
      term_occurrences[term] += count
    end
    
    def remove_term term, count=nil
      if term_occurrences.key? term
        occurs = term_occurrences[term]
        count ||= occurs
        decr = occurs > count ? count : occurs
        term_occurrences[term] -= decr
        term_occurrences.delete(term) if term_occurrences[term] == 0
        decr
      else
        0
      end
    end
    
    def occurrences_of term
      term_occurrences.key?(term) ? term_occurrences[term] : 0
    end
    
    def total_occurrences
      term_occurrences.inject(0) { |sum, (w,c)| sum + c }
    end
    
    def total_unique
      term_occurrences.size
    end
    
    def unique_terms
      term_occurrences.keys
    end
  end
end
