# encoding: utf-8

# Author::    Ian D. Eccles
# Copyright:: Copyright (c) 2011 Ian D. Ecles
# License::   LGPL

module SimpleBayes
  # Categories are going to be a shared idea, so why not break out the
  # common category functionality into its own class.
  class Category
    attr_reader :name
    
    def initialize name
      @name = name
      @term_counts = Hash.new { |h,k| h[k] = 0 }
    end
    
    def store term, count=1
      @term_counts[term] += count
    end
    
    def remove term, count=nil
      if @term_counts.key? term
        cur = @term_counts[term]
        count ||= cur
        (count < cur ? count : cur).tap do |decr|
          @term_counts[term] -= decr
          @term_counts.delete(term) if @term_counts[term] == 0
        end
      else
        0
      end
    end
    
    def count term
      if @term_counts.key? term
        @term_counts[term]
      else
        0
      end
    end
    
    def count_unique
      @term_counts.select { |t,c| c > 0 }.size
    end
  end
end
