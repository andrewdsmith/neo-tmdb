module TMDb

  # This class is a Null Object version of the +Person+ class.
  #
  class NullPerson
    attr_accessor :adult, :also_known_as, :biography, :birthday,
      :deathday, :homepage, :id, :name, :place_of_birth, :profile_path

    attr_writer :profile_image_url

    def profile_image_url(size)
      @profile_image_url
    end
  end
end
