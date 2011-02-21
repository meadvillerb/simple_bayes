module Classifier
  
  class LSI
    def migrate
      raise "No database defined!" unless @db

      table_query = "SELECT name FROM sqlite_master WHERE type='table'"
      tables = @db[table_query].map { |t| t[:name] }
      if tables.any?
        missing =
          %w(words word_lists categories categories_content_nodes) - tables
        raise "Missing tables #{missing.join(", ")}" if missing.any?
        
        return
      end
      
      @db.create_table :settings do
        primary_key :id

        String  :name, :unique => true, :null => false
        Integer :val
      end
      
      @db.create_table :content_nodes do
        primary_key :id
        String :retrieval_key, :unique => true, :null => false
        Text :source, :null => false
        
        Text :raw_vector
        Text :raw_norm
        Text :lsi_vector
        Text :lsi_norm
        
        index :id
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
        
        index :category_id
        index :content_node_id
      end
    end
  end
  
end