require 'spec_helper'

describe SimpleBayes::TermOccurrence do
  let(:term_occurrence) {
    mock("occurrences").tap do |m|
      m.extend SimpleBayes::TermOccurrence
      m.stub(:term_occurrences => term_occurrences)
    end
  }
  let(:term_occurrences) { Hash.new }
  let(:document) {
    {
      'this' => 3,
      'is' => 19,
      'tests' => 1
    }
  }
  
  it "should add terms from a document" do
    term_occurrence.store_document(document)
    term_occurrence.occurrences_of('this').should  == 3
    term_occurrence.occurrences_of('is').should    == 19
    term_occurrence.occurrences_of('tests').should == 1
  end
  
  it "should remove terms from a document" do
    term_occurrence.store_document(document)
    term_occurrence.remove_document({ 'this' => 2, 'is' => 9001})
    term_occurrence.occurrences_of('this').should  == 1
    term_occurrence.occurrences_of('is').should    == 0
    term_occurrence.occurrences_of('tests').should == 1
  end
  
  it "should keep a record of terms stored" do
    term_occurrence.store_term 'hello', 5
    term_occurrence.store_term 'world', 2
    term_occurrence.store_term 'hello', 3
    term_occurrence.occurrences_of('hello').should == 8
    term_occurrence.occurrences_of('world').should == 2
  end
  
  it "should keep a record of terms removed" do
    term_occurrence.store_term 'hello', 37
    term_occurrence.remove_term 'hello', 18
    term_occurrence.occurrences_of('hello').should == 19
  end
  
  it "should return the number of occurrences of a term actually removed" do
    term_occurrence.store_term 'hello', 37
    term_occurrence.remove_term('hello', 25).should == 25
    term_occurrence.remove_term('hello', 9000).should == 12
    term_occurrence.remove_term('hello').should == 0
    term_occurrence.unique_terms.should_not include('hello')
  end
  
  it "should remove all counts for a term if count is not specified" do
    term_occurrence.store_term 'hello', 37
    term_occurrence.remove_term 'hello'
    term_occurrence.occurrences_of('hello').should == 0
  end
  
  it "should record a term as occurring once if no count is specified" do
    term_occurrence.store_term 'hello'
    term_occurrence.occurrences_of('hello').should == 1
  end
  
  it "should count unknown terms as 0" do
    term_occurrence.occurrences_of('mclargehuge').should == 0
  end
  
  it "should count the number of unique terms" do
    term_occurrence.store_term 'hello', 5
    term_occurrence.store_term 'world', 2
    term_occurrence.remove_term 'hello', 5
    term_occurrence.total_unique.should == 1
  end
  
  it "should count all occurrences of all terms" do
    term_occurrence.store_term 'hello', 5
    term_occurrence.store_term 'world', 3
    term_occurrence.remove_term 'hello', 1
    term_occurrence.total_occurrences.should == 7
  end
  
  it "should calculate the frequency of a term" do
    term_occurrence.store_term 'hello', 5
    term_occurrence.store_term 'world', 3
    term_occurrence.remove_term 'hello', 1
    term_occurrence.frequency_of('hello').should == (4 / 7.0)
    term_occurrence.frequency_of('world').should == (3 / 7.0)
    term_occurrence.frequency_of('nothing').should == 0.0
  end
end
