Feature: Find people by name

  You can search for people by name.

  Note: Currently, only attributes returned in the TMDb search API are
  available in the Person objects. This should be fixed in future.

  Scenario: Find people with a name that includes "Reeves"
    Given my TMDb API key in environment variable TMDB_API_KEY
    When I run the following code:
      """
      require 'neo-tmdb'
      TMDb.configure {|c| c.api_key = ENV['TMDB_API_KEY'] }

      people = TMDb::Person.where(:name => 'Reeves')
      people.each do |person|
        puts "#{person.name} has TMDb id #{person.id}"
      end
      """
    Then each line of the output should contain "Reeves"
