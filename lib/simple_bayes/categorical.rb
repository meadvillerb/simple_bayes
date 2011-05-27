# encoding: utf-8

# Author::    Ian D. Eccles
# Copyright:: Copyright (c) 2011 Ian D. Ecles
# License::   LGPL

module SimpleBayes
  module Categorical
    def create_categories cats
      cats.each { |c| add_category c }
    end
    
    def category_names
      categories.values.map { |c| c.name }
    end
    
    def category name
      categories[name.to_sym]
    end

    def add_category name
      categories[name.to_sym] = Category.new(name)
    end
    
    def remove_category name
      categories.delete(name.to_sym)
    end
    
    # def count_term term
    #   categories.inject(0) { |sum, (_,c)| sum + c.count_term(term) }
    # end
    # 
    # def count_documents
    #   categories.inject(0) { |sum, (_,c)| sum + c.count_documents }
    # end
    # 
    # def count_unique_terms
    #   categories.inject(0) { |sum, (_,c)| sum + c.count_unique_terms }
    # end
    # 
    # def count_terms
    #   categories.inject(0) { |sum, (_,c)| sum + c.count_terms }
    # end
  end
end
