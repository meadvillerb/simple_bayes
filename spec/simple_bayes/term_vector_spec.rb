require 'spec_helper'

describe SimpleBayes::TermVector do
  let(:terms) {
    mock('terms', :term_occurrences => {
      'hello' => 19,
      'there' => 310,
      'testing' => 9,
      'faces' => 2
    })
  }
  let(:vector) { SimpleBayes::TermVector.new(terms) }
  
  it "should access components with []" do
    vector['hello'].should == 1
    vector['faces'].should == 1
    vector['nothing'].should == 0
  end
  
  it "should return a list of its terms" do
    vector.terms.should =~ ['hello', 'there', 'testing', 'faces']
  end
  
  it "should calculate a norm" do
    vector.norm.should == 2.0
  end
  
  it "should measure components with a provided block" do
    vector2 = SimpleBayes::TermVector.new(terms) do |t|
      t.length
    end
    vector2['hello'].should == 5
    vector2['testing'].should == 7
    vector2['nothing'].should == 0
    vector2.norm.should == Math.sqrt(25 + 25 + 49 + 25)
  end
  
  it "should calculate the cosine of the angle between it and another" do
    other_terms = mock('other terms', :term_occurrences => {
      'fresh' => 1,
      'testing' => 5,
      'there' => 3,
      'help' => 2,
      'pants' => 4,
      'fridge' => 9,
      'lost' => 6,
      'kitten' => 8,
      'popsicle' => 7
    })
    other_vector = SimpleBayes::TermVector.new(other_terms)
    # Norms should be 2.0 and 3.0
    # dot product should be 2
    vector.cosine(other_vector).should == 1 / 3.0
  end
end
