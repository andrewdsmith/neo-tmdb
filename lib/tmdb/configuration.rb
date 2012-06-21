module TMDb
  class Configuration
    attr_accessor :api_key, :cache

    def initialize
      @cache = NullCache.new
    end

    # Returns the base URL for use in constructing image URLs.
    def image_base_url
      tmdb_config_images['base_url']
    end

    # Returns the list of film backdrop image sizes for use in constructing
    # image URLs.
    def image_backdrop_sizes
      tmdb_config_images['backdrop_sizes']
    end

    # Returns the list of film poster image sizes for use in constructing image
    # URLs.
    def image_poster_sizes
      tmdb_config_images['poster_sizes']
    end

    # Returns the list of person profile image sizes for use in constructing
    # image URLs.
    def image_profile_sizes
      tmdb_config_images['profile_sizes']
    end

    protected

    def tmdb_config_images
      @tmdb_config ||= TMDb.get_api_response('configuration')
      @tmdb_config['images']
    end
  end
end
