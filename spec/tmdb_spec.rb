require 'spec_helper'

describe TMDb do
  describe ".configuration" do
    it "returns a TMDb::Configuration object" do
      TMDb.configuration.should be_a(TMDb::Configuration)
    end
    it "returns the same object each time" do
      TMDb.configuration.should be(TMDb.configuration)
    end
  end

  describe ".configure" do
    it "yields the configuration" do
      expect {|blk| TMDb.configure(&blk) }.to yield_with_args(TMDb.configuration)
    end
  end

  describe ".get_api_response" do
    let(:example_path) { 'test/path' }
    let(:example_params) { { :a => '1', :b => 'two' } }
    let(:example_api_key) { '345' }
    let(:example_response) { '{ "c": 6 }' }
    let(:expected_url) { 'http://api.themoviedb.org/3/test/path' }
    let(:expected_query) { example_params.merge(:api_key => example_api_key) }
    before(:each) do
      # We use webmock instead of VCR as these are abstract HTTP tests.
      # TODO: This has been addressed in vcr recently by
      # https://github.com/myronmarston/vcr/issues/146, so the following may
      # become redundant when we upgrade vcr.
      VCR.turn_off!
      stub_request(:get, expected_url).
        with(:query => hash_including(example_params)).
        to_return(:body => example_response)
      TMDb.configure {|config| config.api_key = example_api_key }
    end
    after(:each) do
      # The vcr configuration is stateful between examples so we need to switch
      # it back on for other examples that require it to be active.
      VCR.turn_on!
    end
    it 'makes an HTTP request with the given path, params and TMDb API key' do
      TMDb.get_api_response(example_path, example_params)
      a_request(:get, expected_url).with(:query => expected_query).should have_been_made
    end
    it 'returns the JSON response as a parsed object' do
      response = TMDb.get_api_response(example_path, example_params)
      response.should == JSON.parse(example_response)
    end
    context 'when not passed params' do
      let(:example_params) { { } }
      it 'defaults to no parameters' do
        TMDb.get_api_response(example_path)
        a_request(:get, expected_url).with(:query => expected_query).should have_been_made
      end
    end
    context 'when not configured with a cache' do
      it 'makes an HTTP request once per call with same parameters' do
        3.times { TMDb.get_api_response(example_path, example_params) }
        a_request(:get, expected_url).with(:query => expected_query).should have_been_made.times(3)
      end
    end
    context 'when configured with a cache' do
      it 'makes a single HTTP request per call with same parameters' do
        [1, 2].each do |n|
          stub_request(:get, "http://api.themoviedb.org/3/path#{n}").
            with(:query => hash_including({})).
            to_return(:body => example_response)
        end
        TMDb.configure {|config| config.cache = ActiveSupport::Cache::MemoryStore.new }
        3.times do
          TMDb.get_api_response('path1')
          TMDb.get_api_response('path2')
          TMDb.get_api_response('path1', 'param' => '1')
          TMDb.get_api_response('path1', 'param' => '2')
        end
        a_request(:get, 'http://api.themoviedb.org/3/path1')
          .with(:query => { :api_key => example_api_key }).should have_been_made.times(1)
        a_request(:get, 'http://api.themoviedb.org/3/path2')
          .with(:query => { :api_key => example_api_key }).should have_been_made.times(1)
        a_request(:get, 'http://api.themoviedb.org/3/path1').
          with(:query => hash_including({ 'param' => '1' })).should have_been_made.times(1)
        a_request(:get, 'http://api.themoviedb.org/3/path1').
          with(:query => hash_including({ 'param' => '2' })).should have_been_made.times(1)
      end
    end
  end
end
