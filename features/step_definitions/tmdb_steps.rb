Before do |scenario|
  @vcr_cassette = "#{scenario.feature.name.split("\n").first}/#{scenario.name}".downcase
end

Given /^my TMDb API key in environment variable TMDB_API_KEY$/ do
  # We cannot verify the environement variable here as it's only truely
  # required when we're recording a vcr cassette. The vcr configuration code
  # intercepts real requests and checks that the environment variable is set.
  # This way, it's possible to run the the scenarios without a TMDb API key
  # using the vcr cassettes. This is useful in a public CI environment like
  # Travis, where we don't want to expose a key.
end

Given /^the TMDb service is unavailable$/ do
  @code_template = %!
    require 'webmock'
    include WebMock::API
    stub_request(:any, /.*/).to_return(:status => 503)

    %{code}
  !
end

When /^I run the following code:$/ do |code|
  @code_template ||= %!
    require 'vcr'

    # In the absense of the TMDB_API_KEY environment variable we have to use a
    # fake string because vcr refuses to perform placeholder substitution if
    # given a blank.
    ENV['TMDB_API_KEY'] = 'fake_tmdb_api_key' unless ENV['TMDB_API_KEY']

    VCR.configure do |c|
      c.hook_into :faraday
      c.cassette_library_dir = '../../features/cassettes'
      c.default_cassette_options = { :record => :new_episodes }
      c.filter_sensitive_data('TMDB_API_KEY') { ENV['TMDB_API_KEY'] }
      c.before_http_request do |request|
        # Log requests for verification in later steps.
        STDERR.puts "Request made to \#{request.uri}"
      end
      c.before_http_request(:real?) do |request|
        if TMDb.configuration.api_key == 'fake_tmdb_api_key'
         raise "You cannot run this test without setting the TMDB_API_KEY " +
           "environment variable to your TMDb API key as a real HTTP request " +
           "to the TMDb must be made."
        end
      end
    end

    VCR.use_cassette('#{@vcr_cassette}') do
      %{code}
    end
  !
  code = @code_template % { :code => code }
  write_file('scenario.rb', code)
  run_simple('ruby scenario.rb')
end

Then /^each line of the output should contain "(.*?)"$/ do |string|
  all_stdout.each_line {|line| line.should match(/#{string}/) }
end

Then /^only one request to the TMDb servers should be made$/ do
  all_stderr.scan(/^Request made/).should have(1).match
end

Then /^the output should be an HTTP URL$/ do
  all_stdout.should be_an_http_url
end
