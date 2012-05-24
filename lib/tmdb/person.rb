module TMDb
  class Person
    attr_reader :id, :name

    def initialize(args)
      @id = args["id"]
      @name = args["name"]
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
      connection = Faraday.new(:url => 'http://api.themoviedb.org/3/') do |builder|
        builder.request :url_encoded
        builder.adapter :net_http
      end
      response = connection.get(
        "search/person",
        :query => args[:name],
        :api_key => TMDb.configuration.api_key
      )
      body = JSON.parse(response.body)
      body["results"].map {|attrs| new(attrs) }
    end
  end
end
