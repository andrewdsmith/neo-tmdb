require 'spec_helper'

module TMDb
  describe Configuration do
    let(:config) { Configuration.new }
    describe "#api_key" do
      it "remembers the API key" do
        config.api_key = "1234"
        config.api_key.should == "1234"
      end
    end
  end
end
