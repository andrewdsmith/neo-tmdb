require File.expand_path('../lib/tmdb/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'neo-tmdb'
  s.version = TMDb::VERSION
  s.author = 'Andrew Smith'
  s.summary = 'A wrapper for the v3 TMDb API from www.themoviedb.org'
  s.homepage = 'https://github.com/andrewdsmith/neo-tmdb'
  s.license = 'MIT'

  s.platform = Gem::Platform::RUBY

  s.add_runtime_dependency 'faraday', '~> 0.8.0'

  s.add_development_dependency 'aruba', '~> 0.4'
  s.add_development_dependency 'activesupport', '~> 3.2'
  s.add_development_dependency 'cucumber', '~> 1.2'
  s.add_development_dependency 'rspec', '~> 2.10'
  s.add_development_dependency 'webmock', '~> 1.8'
  s.add_development_dependency 'vcr', '~> 2.2'

  s.files = Dir['lib/**/*.rb', 'LICENSE', '*.markdown']
  s.require_path = 'lib'
end
