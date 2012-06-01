require 'neo-tmdb'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :faraday
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  # In RSpec 3 this will no longer be necessary.
  config.treat_symbols_as_metadata_keys_with_true_values = true
end

api_key = ENV["TMDB_API_KEY"] or raise "You must set the TMDB_API_KEY environment variable to run these tests."

TMDb.configure do |config|
  config.api_key = api_key
end
