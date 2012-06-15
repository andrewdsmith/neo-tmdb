module TMDb
  class Configuration
    attr_accessor :api_key

    def images_base_url
      @tmdb_config ||= TMDb.get_api_response('configuration')
      @tmdb_config['images']['base_url']
    end
  end
end
