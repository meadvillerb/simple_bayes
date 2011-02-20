module Classifier
  class LSI
    
    class Version
      include DataMapper::Resource
  
      property :id, Serial
      property :version, Integer
    end
    
  end
end