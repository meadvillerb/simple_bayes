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
    
    def categories_including term
      categories.values.select { |c| c.occurrences_of(term) > 0 }
    end
    
    def inverse_frequency_of term
      including = categories_including(term).size
      return 0 if including.zero?
      Math.log( categories.size / including.to_f )
    end
  end
end
