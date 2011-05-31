require 'spec_helper'

describe SimpleBayes::Category do
  let(:category) { SimpleBayes::Category.new 'unnamed' }
  
  it "should include TermOccurrence" do
    category.should be_a_kind_of(SimpleBayes::TermOccurrence)
  end
  
  it "should calculate its log probability based on the unique terms of itself and a classifier" do
    category.stub(:total_unique => 8)
    category.log_probability(32.0).should be_within(1.0e-10).of(Math.log 0.25)
  end
  
  it "should return the 'biggest' negative float if either it or the classifier lack unique terms" do
    category.stub(:total_unique => 0)
    category.log_probability(32.0).should == -Float::MAX
    category.stub(:total_unique => 8)
    category.log_probability(0.0).should == -Float::MAX
  end
  
  it "should calculate its probability based on the unique terms of itself and a classifier" do
    category.stub(:total_unique => 8)
    category.probability(32.0).should be_within(1.0e-10).of(0.25)
  end
  
  it "should be close to 0 if either it or the classifier lack unique terms" do
    category.stub(:total_unique => 0)
    category.probability(32.0).should be_within(1.0e-10).of(0.0)
    category.stub(:total_unique => 8)
    category.probability(0.0).should be_within(1.0e-10).of(0.0)
  end
  
  it "should calculate the log probability of a document given the category" do
    category.stub(:total_occurrences => 100)
    category.stub(:occurrences_of).with('this') { 20 }
    category.stub(:occurrences_of).with('that') { 10 }
    category.stub(:occurrences_of).with('other') { 5 }
    category.log_probability_of_document({
      'this' => 56,
      'that' => 9001,
      'other' => 19 }).should be_within(1.0e-10).of(Math.log(0.05 * 0.1 * 0.2))
  end
  
  it "should be the 'biggest' negative float for log probability if we have no terms" do
    category.stub(:total_occurrences => 0)
    category.log_probability_of_document({
      'this' => 56,
      'that' => 9001,
      'other' => 19 }).should == -Float::MAX
  end
  
  it "should calculate the probability of a document given the category" do
    category.stub(:total_occurrences => 100)
    category.stub(:occurrences_of).with('this') { 20 }
    category.stub(:occurrences_of).with('that') { 10 }
    category.stub(:occurrences_of).with('other') { 5 }
    category.probability_of_document({
      'this' => 56,
      'that' => 9001,
      'other' => 19 }).should be_within(1.0e-10).of(0.05 * 0.1 * 0.2)
  end
  
  it "should be close to 0 for probability if we have no terms" do
    category.stub(:total_occurrences => 0)
    category.probability_of_document({
      'this' => 56,
      'that' => 9001,
      'other' => 19 }).should be_within(1.0e-10).of(0.0)
  end
  
  it "probability should respect a default probability for unknown terms" do
    category.stub(:total_occurrences => 100)
    category.stub(:occurrences_of).with('this') { 20 }
    category.stub(:occurrences_of).with('that') { 10 }
    category.stub(:occurrences_of).with('other') { 0 }
    category.probability_of_document({
      'this' => 56,
      'that' => 9001,
      'other' => 19 }, 0.01).should be_within(1.0e-10).of(0.01 * 0.1 * 0.2)
  end
  
  it "log probability should respect a default probability for unknown terms" do
    category.stub(:total_occurrences => 100)
    category.stub(:occurrences_of).with('this') { 20 }
    category.stub(:occurrences_of).with('that') { 0 }
    category.stub(:occurrences_of).with('other') { 5 }
    category.log_probability_of_document({
      'this' => 56,
      'that' => 9001,
      'other' => 19 }, 0.03).should be_within(1.0e-10).of(Math.log(0.05 * 0.03 * 0.2))
  end
end
