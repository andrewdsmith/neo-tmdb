module TMDb
  extend self

  # Returns the global TMDb configuration.
  def configuration
    @configuration ||= Configuration.new
  end

  # Configure TMDb by calling this method.
  def configure
    yield configuration
  end
end
