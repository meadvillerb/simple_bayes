# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

describe SimpleBayes::WordHash do
	before(:each) do
		@word_hash = SimpleBayes::WordHash.new("23 skidoo! What'd you say about 23!? I heard you say something 23.")
	end
	
	it "should strip punctuation" do
		@word_hash.keys.each do |word|
			word.should match /\w/i
		end
	end
	
	it "should return a hash with 'uncommon' words as keys" do
		@word_hash.keys.should eq ["23","skidoo","what'd","say","about","heard","something"]
		@word_hash.keys.count.should eq 7
	end
	
	it "should return a hash with word frequencies as values" do
		hash = { "23" => 3, "skidoo" => 1, "what'd" => 1, "say" => 2, "about" => 1, "heard" => 1, "something" => 1 }
		@word_hash.should eq hash
	end
end
