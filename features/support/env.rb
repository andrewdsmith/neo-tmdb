# Let us run cucumber without the `bundle exec` prefix.
require 'bundler'
Bundler.setup

# Load aruba step defs and API.
require 'aruba/cucumber'
