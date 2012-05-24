require 'neo-tmdb'

api_key = ENV["TMDB_API_KEY"] or raise "You must set the TMDB_API_KEY environment variable to run these tests."

TMDb.configure do |config|
  config.api_key = api_key
end
