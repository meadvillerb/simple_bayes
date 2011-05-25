describe SimpleBayes do
  describe "VERSION" do
    it "should have a VERSION constant" do
      subject::VERSION.should_not be_empty
    end
  end
end