Feature: Person profile image URL

  You can get a person's complete profile image URL for any of the configured
  profile image sizes with a single call to `profile_image_url`.
  
  Scenario: Smallest profile image URL for Keanu Reeves
    Given my TMDb API key in environment variable TMDB_API_KEY
    When I run the following code:
      """
      require 'neo-tmdb'
      TMDb.configure {|c| c.api_key = ENV['TMDB_API_KEY'] }

      person = TMDb::Person.find(6384)
      smallest = TMDb.configuration.image_profile_sizes.first
      puts person.profile_image_url(smallest)
      """
    Then the output should be an HTTP URL

