module TMDb
  extend self

  # Returns the global TMDb configuration.
  #
  def configuration
    @configuration ||= Configuration.new
  end

  # Configure TMDb by calling this method.
  #
  def configure
    yield configuration
  end

  # Makes a TMDb API request given to the (relative) +path+ with the given
  # query +params+ and using the configured API key. Returns the response as a
  # hash (parsed from the original JSON). This method is not intended to be
  # called directly by client code, instead you should call methods such as
  # +Person.find+ that return TMDb wrapper objects.
  #
  def get_api_response(path, params = {})
    configuration.cache.fetch([path, params]) do
      connection = Faraday.new(:url => 'http://api.themoviedb.org/3/') do |builder|
        builder.request :url_encoded
        builder.adapter :net_http
      end
      response = connection.get(
        path,
        params.merge({ :api_key => TMDb.configuration.api_key })
      )
      JSON.parse(response.body)
    end
  end
end
