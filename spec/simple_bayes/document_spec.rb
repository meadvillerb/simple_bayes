# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

describe SimpleBayes::Document do
  let(:document) {
    SimpleBayes::Document.new("23 skidoo! What'd you say about 23!? I heard you say something 23.")
  }

	it "should strip punctuation" do
		document.unique_terms.each do |word|
			word.should match /\w/i
		end
	end
	
	it "should return a hash with 'uncommon' words as keys" do
		document.unique_terms.should eq ["23","skidoo","what'd","say","about","heard","something"]
		document.total_unique.should eq 7
	end
	
	it "should return term occurrences when accessed like a hash" do
	  document["say"].should == 2
	  document["23"].should == 3
	  document["you"].should == 0
	end
	
	it "should iterate over the internal hash of occurrences" do
	  collected = {}
	  document.each do |term, occurs|
	    collected[term] = occurs
    end
    collected.should == {
      '23' => 3,
      'skidoo' => 1,
      "what'd" => 1,
      'say' => 2,
      'about' => 1,
      'heard' => 1,
      'something' => 1
    }
	end
	
	it "should be enumerable" do
	  document.should be_a_kind_of(Enumerable)
	end
end
