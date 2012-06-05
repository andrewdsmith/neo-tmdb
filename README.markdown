# Neo TMDb

Neo TMDb is a Ruby wrapper for the v3 [TMDb API][api] from www.themoviedb.org.

[api]: http://help.themoviedb.org/kb/api/about-3

## Use

Currently you can only search for people by name and discover their id. Only
the first 20 results for searches are returned.

require 'neo-tmdb'

```ruby
TMDb.configure do |config|
  # You must configure this library with a TMDb API key before you can use it.
  config.api_key = 'my-tmdb-api-key-here'
end

people = TMDb::Person.where(:name => "Reeves")
people.each do |person|
  puts "#{person.name} has TMDb id #{person.id}"
end
```

## Contribute

* Source hosted on [GitHub][].
* Report issues on [GitHub Issues][].
* Pull requests are very welcome! Please include spec coverage for every patch
  and create a topic branch for every separate change you make.

[GitHub]: https://github.com/andrewdsmith/neo-tmdb
[GitHub Issues]: https://github.com/andrewdsmith/neo-tmdb/issues

## Copyright

See LICENSE for details.

