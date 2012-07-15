Feature: Fault tolerance

  By default, the `Person.find` method will return a `NullPerson` instance if
  the TMDb service is unavailable. This saves you having to explicitly catch
  the exception.

  If you configure the null person with `nil`, calls to `Person.find` will
  raise a `TMDb::ServiceUnavailable` exception in the event the service is
  unavailable (and your locally configured cache misses).

  Background: 
    Given my TMDb API key in environment variable TMDB_API_KEY
    And the TMDb service is unavailable

  Scenario: With the default null person configured
    When I run the following code:
      """
      require 'neo-tmdb'

      TMDb.configure do |config|
        config.api_key = ENV['TMDB_API_KEY']
      end

      person = TMDb::Person.find(6384)
      puts "> #{person.name} - #{person.birthday} - #{person.profile_image_url(:any_size)} <"
      """
    Then the output should contain ">  -  -  <"

  Scenario: With a custom null person configured
    When I run the following code:
      """
      require 'neo-tmdb'

      null_person = TMDb::NullPerson.new
      null_person.name = 'Unknown'
      null_person.birthday = nil
      null_person.profile_image_url = 'http://example.com/no_image.jpg'

      TMDb.configure do |config|
        config.api_key = ENV['TMDB_API_KEY']
        config.null_person = null_person
      end

      person = TMDb::Person.find(6384)
      puts "> #{person.name} - #{person.birthday} - #{person.profile_image_url(:any_size)} <"
      """
    Then the output should contain "> Unknown -  - http://example.com/no_image.jpg <"

  Scenario: With no null person configured
    When I run the following code:
      """
      require 'neo-tmdb'

      TMDb.configure do |config|
        config.api_key = ENV['TMDB_API_KEY']
        config.null_person = nil
      end

      begin
        person = TMDb::Person.find(6384)
      rescue TMDb::ServiceUnavailable
        puts 'Service unavailable'
      end
      """
    Then the output should contain "Service unavailable"

