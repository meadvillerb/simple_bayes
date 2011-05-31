# encoding: utf-8

# Author::    Ian D. Eccles
# Copyright:: Copyright (c) 2011 Ian D. Ecles
# License::   LGPL


# There is probably some factoring / composing to be done between this
# and TermOccurrence to get one module/class to handle all the term related
# counting business.
module SimpleBayes
  class TermVector
    DEFAULT_MEASUREMENT = lambda { |t| 1 }
    
    def initialize doc, &measure
      measure ||= DEFAULT_MEASUREMENT
      @vector = Hash[doc.term_occurrences.map { |t, _| [t, measure.call(t)] }]
    end
    
    def [] term
      @vector.key?(term) ? @vector[term] : 0
    end
    
    def terms; @vector.keys; end
    
    def norm
      Math.sqrt( terms.inject(0) { |sum, t| sum + self[t]*self[t] } )
    end
    
    # Returns cos A, where A is the angle between this vector and the
    # other.
    def cosine other
      dot_prod = terms.inject(0) do |sum, t|
        sum + self[t] * other[t]
      end
      norms = norm * other.norm
      dot_prod / norms.to_f
    end
    
    class << self
      # With the ability to pass a component calculation via a block,
      # it doesn't make sense to keep a separate TermVector subclass around.
      def tf_idf doc, idf
        new(doc) do |t|
          doc.frequency_of(t) * idf.inverse_frequency_of(t)
        end
      end
    end
  end
end
