Feature: Find person by id

  You can find a person using their TMDb id.

  Scenario: Find Keanu Reeves by his id
    Given my TMDb API key in environment variable "TMDB_API_KEY"
    And a file named "keanu.rb" with:
      """
      require 'neo-tmdb'
      TMDb.configure {|c| c.api_key = ENV['TMDB_API_KEY'] }

      person = TMDb::Person.find(6384)
      puts "#{person.name}, born #{person.birthday} in #{person.place_of_birth}"
      """
    When I successfully run `ruby keanu.rb`
    Then the output should contain:
      """
      Keanu Reeves, born 1964-09-02 in Beirut, Lebanon
      """
