# encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

describe SimpleBayes::Bayes do
  before(:all) do
    @b = SimpleBayes::Bayes.new :interesting, :uninteresting
  end
  
	it "should allow categories to be assigned during initialization" do
	  @b.categories.should eq [:interesting, :uninteresting]
	end
	
	it "should allow categories to be added after initialization" do
	  @b.add_category :spam
	  @b.categories.should eq [ :interesting, :uninteresting, :spam ]
	end
	
	it "should allow categories to be removed" do
	  @b.remove_category :spam
	  @b.categories.should eq [:interesting, :uninteresting]
	end
	
	it "should allow categories to be trained" do
	  int_hash = {"text" => 1, "interesting" => 1}
	  unint_hash = {"text" => 1, "uninteresting" => 1}
	  @b.train :interesting, "This text is interesting."
	  @b.train :uninteresting, "This text is uninteresting."
	  @b.instance_variable_get(:@categories)[:interesting].should eq int_hash
	  @b.instance_variable_get(:@categories)[:uninteresting].should eq unint_hash
	end

  it "should allow categories to be untrained" do
    @b.untrain :interesting, "This text is interesting."
    @b.instance_variable_get(:@categories)[:interesting].should eq Hash.new
  end
	
end
