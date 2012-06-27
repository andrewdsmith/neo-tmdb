require 'active_support'
require 'neo-tmdb'
require 'webmock/rspec'
require 'vcr'

# Allow VCR to process real HTTP requests.
WebMock.allow_net_connect!

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :faraday
  config.configure_rspec_metadata!
  config.filter_sensitive_data('TMDB_API_KEY') { TMDb.configuration.api_key }
  config.before_http_request(:real?) do |request|
    if TMDb.configuration.api_key == :fake_tmdb_api_key
      raise "You cannot run this test without setting the TMDB_API_KEY " +
        "environment variable to your TMDb API key as a real HTTP request " +
        "to the TMDb must be made."
    end
  end
end

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  # In RSpec 3 this will no longer be necessary.
  config.treat_symbols_as_metadata_keys_with_true_values = true
end

TMDb.configure do |config|
  # In the absense of the TMDB_API_KEY environment variable we have to use a
  # fake string because vcr refuses to perform placeholder substitution if
  # given a blank.
  key = ENV['TMDB_API_KEY']
  config.api_key = key.nil? || key.empty? ? :fake_tmdb_api_key : key
end
