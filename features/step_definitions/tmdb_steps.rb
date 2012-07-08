Given /^my TMDb API key in environment variable "(.*?)"$/ do |name|
  unless ENV[name]
    fail "To run this scenario environment variable '#{name}' must contain a valid TMDb API key."
  end
end
