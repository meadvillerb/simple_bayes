module Classifier
  class LSI
    
    class Word
      include DataMapper::Resource
  
      property :id, Serial
      property :stem, String
    end
    
  end
end