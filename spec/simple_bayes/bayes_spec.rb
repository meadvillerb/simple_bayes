# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

describe SimpleBayes::Bayes do
  let(:classifier) {
    SimpleBayes::Bayes.new :interesting, :uninteresting
  }
  
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
  
  it "should have some half-assed classify tests" do
    classifier.train :interesting, "This text is interesting."
    classifier.classify("Is this interesting?").should eq :interesting
  end
	
end
