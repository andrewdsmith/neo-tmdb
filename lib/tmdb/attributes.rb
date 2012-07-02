module TMDb

  # A module for managing TMDb-derived attributes of a class.
  #
  module Attributes

    # Adds an attribute reader with the given +name+ (symbol) that delegates to
    # the instance's +@tmdb_attrs+ hash entry of the same name.
    #
    def tmdb_attr(name)
      define_method(name) { @tmdb_attrs[name.to_s] }
    end
  end
end
