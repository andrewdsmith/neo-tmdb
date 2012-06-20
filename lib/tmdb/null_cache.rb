module TMDb

  # Looks like a cache but doesn't perform any caching. This helps us avoid
  # checking for whether a cache is configured or not, as per the Null Object
  # pattern: http://en.wikipedia.org/wiki/Null_Object_pattern.
  #
  class NullCache

    # Returns the value of the yielded block. Assumes that a block is passed;
    # ActiveSupport::Cache::Store#fetch allows for no block but we don't use
    # this internally. Ignores +cache_key+ because no caching is performed.
    #
    def fetch(cache_key)
      yield
    end
  end
end
