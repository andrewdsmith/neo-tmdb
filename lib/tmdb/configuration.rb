module TMDb
  class Configuration
    attr_accessor :api_key

    def images_base_url
      @tmdb_config ||= get_api_response("configuration")
      @tmdb_config['images']['base_url']
    end

    protected

    def get_api_response(url, params = {})
      connection = Faraday.new(:url => 'http://api.themoviedb.org/3/') do |builder|
        builder.request :url_encoded
        builder.adapter :net_http
      end
      response = connection.get(
        url,
        params.merge({ :api_key => api_key })
      )
      JSON.parse(response.body)
    end
  end
end
