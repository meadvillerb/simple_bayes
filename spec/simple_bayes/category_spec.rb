require 'spec_helper'

describe SimpleBayes::Category do
  let(:category) { SimpleBayes::Category.new 'unnamed' }
  
  it "should keep a record of terms stored" do
    category.store 'hello', 5
    category.store 'world', 2
    category.store 'hello', 3
    category.count_term('hello').should == 8
    category.count_term('world').should == 2
  end
  
  it "should keep a record of terms removed" do
    category.store 'hello', 37
    category.remove 'hello', 18
    category.count_term('hello').should == 19
  end
  
  it "should return the number of occurrences of a term actually removed" do
    category.store 'hello', 37
    category.remove('hello', 25).should == 25
    category.remove('hello', 9000).should == 12
    category.remove('hello').should == 0
  end
  
  it "should remove all counts for a term if count is not specified" do
    category.store 'hello', 37
    category.remove 'hello'
    category.count_term('hello').should == 0
  end
  
  it "should record a term as occurring once if no count is specified" do
    category.store 'hello'
    category.count_term('hello').should == 1
  end
  
  it "should count unknown terms as 0" do
    category.count_term('mclargehuge').should == 0
  end
  
  it "should count the number of unique terms" do
    category.store 'hello', 5
    category.store 'world', 2
    category.remove 'hello', 5
    category.count_unique_terms.should == 1
  end
  
  it "should count all occurrences of all terms" do
    category.store 'hello', 5
    category.store 'world', 3
    category.remove 'hello', 1
    category.count_terms.should == 7
  end
end
