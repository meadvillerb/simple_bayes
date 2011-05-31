# encoding: utf-8

# Author::    Ian D. Eccles
# Copyright:: Copyright (c) 2011 Ian D. Ecles
# License::   LGPL

module SimpleBayes
  class CosineSimilar
    include Categorical
    
    attr_reader :categories
    
    def initialize *cats
      @categories = {}
      create_categories cats
    end

    def train name, text
      doc = Document.new text
      category(name).store_document doc
    end

    def untrain name, text
      doc = Document.new text
      category(name).remove_document doc
    end
    
    def classifications text
      dv = TermVector.tf_idf(Document.new(text), self)
      categories.values.map do |c|
        [ TermVector.tf_idf(c, self).cosine(dv), c ]
      end
    end
    
    def classify text
      # classifications will be in the range [0, 1]
      classifications(text).inject([-1, nil]) do |max, c_pair|
        max.first > c_pair.first ? max : c_pair
      end.last.name
    end
  end
end
