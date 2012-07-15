require 'spec_helper'

module TMDb
  describe Configuration do
    let(:config) { Configuration.new }
    before(:each) do
      TMDb.stub(:get_api_response) { api_response }
    end

    describe '#api_key' do
      it 'remembers the API key' do
        config.api_key = '1234'
        config.api_key.should == '1234'
      end
    end

    describe '#cache' do
      it 'remembers the cache' do
        config.cache = '1234'
        config.cache.should == '1234'
      end
      it 'defaults to a null cache' do
        config.cache.should be_a(NullCache)
      end
    end

    describe '#null_person' do
      it 'remembers the null person instance' do
        object = Object.new
        config.null_person = object
        config.null_person.should be(object)
      end
      it 'defaults to a NullPerson' do
        config.null_person.should be_a(NullPerson)
      end
    end

    shared_examples :config_reader do |method|
      describe "##{method}" do
        let(:api_response) { { 'images' => { method.to_s.gsub(/^image_/, '') => config_value } } }
        let(:config_value) { 'Example config value' }

        it 'makes an API request to "configuration"' do
          TMDb.should_receive(:get_api_response).with('configuration')
          config.send(method)
        end
        it "returns the #{ method.to_s.gsub('_', ' ') }" do
          config.send(method).should == config_value
        end
        it 'caches the result for subsequent calls' do
          TMDb.should_receive(:get_api_response).once
          2.times { config.send(method) }
        end
      end
    end

    include_examples :config_reader, :image_backdrop_sizes
    include_examples :config_reader, :image_base_url
    include_examples :config_reader, :image_poster_sizes
    include_examples :config_reader, :image_profile_sizes
  end
end
