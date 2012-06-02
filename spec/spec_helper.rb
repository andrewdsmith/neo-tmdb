require 'neo-tmdb'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :faraday
  config.configure_rspec_metadata!
  config.filter_sensitive_data('TMDB_API_KEY') { TMDb.configuration.api_key }
end

RSpec.configure do |config|
  # In RSpec 3 this will no longer be necessary.
  config.treat_symbols_as_metadata_keys_with_true_values = true
end

TMDb.configure do |config|
  # In the absense of the TMDB_API_KEY environment variable we have to use a
  # fake string because vcr refuses to perform placeholder substitution if
  # given a blank.
  key = ENV['TMDB_API_KEY']
  config.api_key = key.nil? || key.empty? ? 'fake-tmdb-api-key' : key
end
