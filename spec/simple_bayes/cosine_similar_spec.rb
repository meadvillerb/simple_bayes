require 'spec_helper'

describe SimpleBayes::CosineSimilar do
  let(:classifier) {
    SimpleBayes::CosineSimilar.new :interesting, :uninteresting
  }
  let(:category) { mock('category') }
  let(:document) { mock('document') }
  
  it "should train categories" do
    SimpleBayes::Document.stub(:new => document)
    category.should_receive(:store_document).with(document)
    classifier.stub(:category => category)
    classifier.train :some_category, "this is a bit of text"
  end
  
  it "should untrain categories" do
    SimpleBayes::Document.stub(:new => document)
    category.should_receive(:remove_document).with(document)
    classifier.stub(:category => category)
    classifier.untrain :some_category, "this is a bit of text"
  end
  
  # Once factored, Bayes had a very simple expression for classifications,
  # not quite so with CosineSimilar
  it "should weight categories based on the angle between them and the text" do
    # idfs:
    #   stuff         => log(2/2)
    #   uninteresting => log(2/1)
    #   text          => log(2/1)
    #   about         => log(2/1)
    #   interesting   => log(2/1)
    #   monotremes    => log(2/1)
    #   platypus      => 0 (ish)
    classifier.train :uninteresting, "uninteresting text stuff"
    classifier.train :interesting, "about interesting monotremes stuff"
    # tf's:
    #  stuff          => 1/5
    #  monotremes     => 2/5
    #  about          => 1/5
    #  platypus       => 1/5
    classifier.classifications("monotremes stuff about monotremes platypus").should =~ [ [0.7745966692414833, classifier.category(:interesting)], [0, classifier.category(:uninteresting)] ]
  end
end
