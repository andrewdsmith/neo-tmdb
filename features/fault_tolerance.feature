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

      begin
        person = TMDb::Person.find(6384)
      rescue TMDb::ServiceUnavailable
        puts 'Service unavailable'
      end
      """
    Then the output should not contain "Service unavailable"

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
