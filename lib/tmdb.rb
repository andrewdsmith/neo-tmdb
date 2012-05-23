module TMDb
  extend self

  # Returns the global TMDb configuration.
  def configuration
    @configuration ||= Configuration.new
  end
end
