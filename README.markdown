# Neo TMDb

Neo TMDb is a Ruby wrapper for the v3 [TMDb API][api] from www.themoviedb.org.

[api]: http://help.themoviedb.org/kb/api/about-3

## Use

Currently you can find people by their TMDb id or search for people.

```ruby
require 'neo-tmdb'

TMDb.configure do |config|
  # You must configure this library with a TMDb API key before you can use it.
  config.api_key = 'my-tmdb-api-key-here'
end

person = TMDb::Person.find(6384)
puts "#{person.name}, born #{person.birthday} in #{person.place_of_birth}"
# => Keanu Reeves, born 1964-09-02 in Beirut, Lebanon

smallest = TMDb.configuration.image_profile_sizes.first
puts person.profile_image_url(smallest)
# => http://cf2.imgobject.com/t/p/w45/jmjeALlAVaPB8SonLR3qBN5myjc.jpg

# Note: Only the first 20 results are returned.
people = TMDb::Person.where(:name => "Reeves")
people.each do |person|
  # Note: Only attributes available in the search API will be populated here.
  puts "#{person.name} has TMDb id #{person.id}"
end
```

Further [documentation can be found on rdoc.info][docs].

[docs]: http://rdoc.info/github/andrewdsmith/neo-tmdb/master/frames

## Contribute

* Source hosted on [GitHub][].
* Report issues on [GitHub Issues][].
* Pull requests are very welcome! Please include spec coverage for every patch
  and create a topic branch for every separate change you make.

[GitHub]: https://github.com/andrewdsmith/neo-tmdb
[GitHub Issues]: https://github.com/andrewdsmith/neo-tmdb/issues

## Copyright

See LICENSE for details.

