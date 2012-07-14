Before do |scenario|
  @vcr_cassette = "#{scenario.feature.name.split("\n").first}/#{scenario.name}".downcase
end

Given /^my TMDb API key in environment variable TMDB_API_KEY$/ do
  unless (ENV['TMDB_API_KEY'])
    fail "To run this scenario environment variable 'TMDB_API_KEY' must contain a valid TMDb API key."
  end
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
    VCR.configure do |c|
      c.hook_into :faraday
      c.cassette_library_dir = '../../features/cassettes'
      c.default_cassette_options = { :record => :new_episodes }
      c.filter_sensitive_data('TMDB_API_KEY') { ENV['TMDB_API_KEY'] }
      c.before_http_request do |request|
        STDERR.puts "Request made to \#{request.uri}"
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
