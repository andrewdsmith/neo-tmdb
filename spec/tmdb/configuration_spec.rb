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

    context "when configured with an API key value" do
      before(:each) do
        # See spec/spec_helper.rb for setup of the API key.
        config.api_key = TMDb.configuration.api_key
      end
      describe "#images_base_url", :vcr => { :cassette_name => "configuration" } do
        it "returns the base URL for images" do
          config.images_base_url.should == "http://cf2.imgobject.com/t/p/"
        end
        it "only hits the url once" do
          # This test currently works because VCR will refuse the second
          # request when replaying the cassette recorded in the first example.
          # This means that if this example will pass if run in isolation or
          # before other examples and vcr is re-recording the cassette.
          expect { 2.times { config.images_base_url } }.to_not raise_error
        end
      end
    end
  end
end
