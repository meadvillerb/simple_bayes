require 'spec_helper'

describe SimpleBayes::Categorical do
  let(:classifier) {
    mock('classifier').tap do |m|
      m.extend SimpleBayes::Categorical
      m.stub(:categories => categories)
    end
  }
  let(:categories) { Hash.new }
  
  it "should add a category" do
    classifier.add_category 'category_1'
    categories.keys.should == [:category_1]
  end
  
  it "should create a set of categories" do
    classifier.create_categories [:cat1, 'CUIDADO LLAMA', :blather_blather]
    # Maybe testing a little closer to metal than need be.
    categories.keys.should =~ [:'CUIDADO LLAMA', :cat1, :blather_blather]
  end
  
  it "should return the names of the categories" do
    classifier.create_categories [:cat1, 'CUIDADO LLAMA', 'blah']
    classifier.category_names.should =~ ['CUIDADO LLAMA', :cat1, 'blah']
  end
  
  it "should fetch a category by string" do
    classifier.create_categories [:cat1, 'CUIDADO LLAMA', 'blah']
    classifier.category('cat1').should be_a_kind_of(SimpleBayes::Category)
  end
  
  it "should fetch a category by symbol" do
    classifier.create_categories [:cat1, 'CUIDADO LLAMA', 'blah']
    classifier.category(:'CUIDADO LLAMA').should be_a_kind_of(SimpleBayes::Category)
  end
  
  it "should return nil for unknown categories" do
    classifier.create_categories [:cat1, 'CUIDADO LLAMA', 'blah']
    classifier.category('lame').should be_nil
  end
  
  it "should remove a category" do
    classifier.create_categories [:cat1, 'CUIDADO LLAMA', :blather_blather]
    classifier.remove_category 'cat1'
    classifier.remove_category :lame
    classifier.category_names.should =~ ['CUIDADO LLAMA', :blather_blather]
  end
end
