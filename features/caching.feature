Feature: Caching

  You can configure caching so that duplicate requests for the same person are
  read from the cache rather than directly from the TMDb servers. This helps
  improve the performance of your application but also prevents it from
  exceeding the [API request limits][1] on the TMDb servers.

  [1]: http://help.themoviedb.org/kb/general/api-request-limits
  
  You should configure your cache to expire entries after an appropriate
  period. Note that MemoryStore may not be the best choice for your
  application.

  You can use any cache that implements ActiveSupport's Cache interface.
  
  Scenario: Find person by id
    Given my TMDb API key in environment variable TMDB_API_KEY
    When I run the following code:
      """
      require 'active_support'
      require 'neo-tmdb'

      TMDb.configure do |config|
        config.api_key = ENV['TMDB_API_KEY']
        config.cache = ActiveSupport::Cache::MemoryStore.new
      end

      3.times do |n|
        person = TMDb::Person.find(6384)
        puts "#{person.name} load #{n}"
      end
      """
    Then only one request to the TMDb servers should be made
