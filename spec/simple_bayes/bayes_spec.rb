# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

describe SimpleBayes::Bayes do
  let(:classifier) {
    SimpleBayes::Bayes.new :interesting, :uninteresting
  }
  let(:stubby_categories) {
    [stubby_cat1, stubby_cat2, stubby_cat3]
  }
  let(:stubby_cat1) {
    mock('category 1', :log_probability => 2, :probability => 9,
      :log_probability_of_document => 91, :probability_of_document => 42,
      :name => 'category 1')
  }
  let(:stubby_cat2) {
    mock('category 2', :log_probability => 17, :probability => 5,
      :log_probability_of_document => 32, :probability_of_document => 14,
      :name => 'category 2')
  }
  let(:stubby_cat3) {
    mock('category 3', :log_probability => 9001, :probability => 42,
      :log_probability_of_document => 7, :probability_of_document => 8,
      :name => 'category 3')
  }
  
  it "should include TermOccurrence" do
    classifier.should be_a_kind_of(SimpleBayes::TermOccurrence)
  end
  
	it "should allow categories to be assigned during initialization" do
	  classifier.category_names.should eq [:interesting, :uninteresting]
	end
	
	it "should return a named category" do
	  classifier.category(:interesting).should be_a_kind_of(SimpleBayes::Category)
	  classifier.category(:unknown).should be_nil
	end
	
	it "should allow categories to be added after initialization" do
	  classifier.add_category :spam
	  classifier.category_names.should eq [ :interesting, :uninteresting, :spam ]
	end
	
	it "should allow categories to be removed" do
	  classifier.remove_category :interesting
	  classifier.category_names.should eq [:uninteresting]
	end
	
	it "should allow categories to be trained" do
	  classifier.train :interesting, "This text is interesting."
	  classifier.train :uninteresting, "This text is uninteresting."
	  classifier.category(:interesting).occurrences_of('text').should == 1
	  classifier.category(:interesting).occurrences_of('interesting').should == 1
	  classifier.category(:uninteresting).occurrences_of('text').should == 1
	  classifier.category(:uninteresting).occurrences_of('uninteresting').should == 1
	end

  it "should allow categories to be untrained" do
    classifier.train :interesting, "This text is interesting."
    classifier.untrain :interesting, "This text is interesting."
	  classifier.category(:interesting).occurrences_of('text').should == 0
	  classifier.category(:interesting).occurrences_of('interesting').should == 0
  end
  
  # We are already testing probability calculations in our Category spec,
  # so all we need to test here is that those numbers are being combined
  # appropriately.
  it "should compute log_classifications for each category" do
    SimpleBayes::Document.should_receive(:new).with('unimportant string')
    classifier.stub(:categories => mock('categories', :values => stubby_categories))
    classifier.log_classifications("unimportant string").should == [
      [93, stubby_cat1], [49, stubby_cat2], [9008, stubby_cat3]
    ]
  end
  
  it "should compute classifications for each category" do
    SimpleBayes::Document.should_receive(:new).with('unimportant string')
    classifier.stub(:categories => mock('categories', :values => stubby_categories))
    classifier.classifications("unimportant string").should == [
      [9*42, stubby_cat1], [5*14, stubby_cat2], [42*8, stubby_cat3]
    ]
  end
  
  it "should pick the category with a log classification score closest to 0" do
    classifier.stub(:log_classifications => [
      [-190, stubby_cat1], [-10, stubby_cat2], [-Float::MAX, stubby_cat3]
    ])
    classifier.classify('unimportant text').should == 'category 2'
  end
end
