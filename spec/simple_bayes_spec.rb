require 'spec_helper'

describe SimpleBayes do
  describe "VERSION" do
    it "should have a VERSION constant" do
      subject::VERSION.should_not be_empty
    end
  end
  
  describe "Convenience method" do
    it "should have a convenience method for creating a new classifier" do
      subject.new.class.should eq SimpleBayes::Bayes
    end
  end
  
end