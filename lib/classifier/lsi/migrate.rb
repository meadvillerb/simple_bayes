module Classifier
  
  class LSI
    def migrate
      raise "No database defined!" unless @db
      
      @db.create_table :content_nodes do
        primary_key :id
        String :retrieval_key, :unique => true, :null => false
        Text :source, :null => false
        index :retrieval_key
      end
      
      @db.create_table :words do
        primary_key :id
        String :stem, :unique => true, :null => false        
        index :stem
      end
      
      @db.create_table :word_lists do
        primary_key :id
        foreign_key :word_id, :words
        foreign_key :content_node_id, :content_nodes
        Integer :frequency

        index :word_id
        index :content_node_id
      end
      
      @db.create_table :categories do
        primary_key :id
        String :name, :unique => true, :null => false
        index :name
      end
      
      @db.create_table :categories_content_nodes do
        primary_key :id
        foreign_key :category_id, :categories
        foreign_key :content_node_id, :content_nodes
      end
    end
  end
  
end