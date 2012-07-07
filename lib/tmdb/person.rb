require 'tmdb/attributes'
require 'tmdb/null_person'

module TMDb
  class Person
    extend Attributes

    tmdb_attr :adult
    tmdb_attr :also_known_as
    tmdb_attr :biography
    tmdb_attr :birthday
    tmdb_attr :deathday
    tmdb_attr :homepage
    tmdb_attr :id
    tmdb_attr :name
    tmdb_attr :place_of_birth
    tmdb_attr :profile_path

    def initialize(args)
      @tmdb_attrs = args
    end

    # Returns the person with TMDb id of +id+.
    #
    def self.find(id)
      begin
        response = TMDb.get_api_response("person/#{id}")
        new(response)
      rescue ServiceUnavailable
        NullPerson.new
      end
    end

    # Returns an enumerable containing all the people matching the
    # condition hash. Currently the only condition that can be specified
    # is name, e.g.
    #
    #   people = Person.where(:name => 'Reeves')
    #
    # Only the first page of results (20 people) are returned.
    #
    def self.where(args)
      response = TMDb.get_api_response('search/person', :query => args[:name])
      response['results'].map {|attrs| new(attrs) }
    end

    # Returns a URL for the person's profile image at the given +size+. Valid
    # sizes should be discovered via the +Configuration.image_profile_sizes+
    # method. Returns nil if the person does not have a profile image.
    #
    def profile_image_url(size)
      if profile_path
        [TMDb.configuration.image_base_url, size, profile_path].join
      end
    end
  end
end
