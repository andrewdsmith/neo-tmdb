Before do |scenario|
  @vcr_cassette = "#{scenario.feature.name.split("\n").first}/#{scenario.name}".downcase
end

Given /^my TMDb API key in environment variable TMDB_API_KEY$/ do
  unless (ENV['TMDB_API_KEY'])
    fail "To run this scenario environment variable 'TMDB_API_KEY' must contain a valid TMDb API key."
  end
end

When /^I run the following code:$/ do |code|
  code = %{
    require 'vcr'
    VCR.configure do |c|
      c.hook_into :faraday
      c.cassette_library_dir = '../../features/cassettes'
      c.default_cassette_options = {:record => :new_episodes }
      c.filter_sensitive_data('TMDB_API_KEY') { ENV['TMDB_API_KEY'] }
    end

    VCR.use_cassette('#{@vcr_cassette}') do
      #{code}
    end
  }
  write_file('scenario.rb', code)
  run_simple('ruby scenario.rb')
end

Then /^each line of the output should contain "(.*?)"$/ do |string|
  all_output.each_line {|line| line.should match(/#{string}/) }
end
