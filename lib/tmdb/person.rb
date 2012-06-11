require 'tmdb/attributes'

module TMDb
  class Person
    extend Attributes

    tmdb_attr :id
    tmdb_attr :name

    def initialize(args)
      @tmdb_attrs = args
    end

    # Returns the person with TMDb id of +id+.
    #
    def self.find(id)
      response = get_api_response("person/#{id}")
      new(response)
    end

    # Returns an enumerable containing all the people matching the
    # condition hash. Currently the only condition that can be specified
    # is name, e.g.
    #
    #   people = Person.where(:name => "Reeves")
    #
    # Only the first page of results (20 people) are returned.
    #
    def self.where(args)
      response = get_api_response("search/person", :query => args[:name])
      response["results"].map {|attrs| new(attrs) }
    end

    protected

    def self.get_api_response(url, params = {})
      connection = Faraday.new(:url => 'http://api.themoviedb.org/3/') do |builder|
        builder.request :url_encoded
        builder.adapter :net_http
      end
      response = connection.get(
        url,
        params.merge({ :api_key => TMDb.configuration.api_key })
      )
      JSON.parse(response.body)
    end
  end
end
