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

    shared_examples :config_reader do |method, expected_value|
      describe "##{method}" do
        it "returns the #{ method.to_s.gsub('_', ' ') }" do
          config.send(method).should == expected_value
        end
        it "caches the result for subsequent calls" do
          # This test currently works because VCR will refuse the second
          # request when replaying the cassette recorded in the first example.
          # This means that if this example will pass if run in isolation or
          # before other examples and vcr is re-recording the cassette.
          expect { 2.times { config.send(method) } }.to_not raise_error
        end
      end
    end

    context "when configured with an API key value", :vcr => { :cassette_name => "configuration" } do
      before(:each) do
        # See spec/spec_helper.rb for setup of the API key.
        config.api_key = TMDb.configuration.api_key
      end
      include_examples :config_reader, :image_backdrop_sizes, ['w300', 'w780', 'w1280', 'original']
      include_examples :config_reader, :image_base_url, 'http://cf2.imgobject.com/t/p/'
      include_examples :config_reader, :image_poster_sizes,  ["w92", "w154", "w185", "w342", "w500", "original"]
      include_examples :config_reader, :image_profile_sizes,  ["w45", "w185", "h632", "original"]
    end
  end
end
