RSpec::Matchers.define :be_an_http_url do
  match do |actual|
    URI.parse(actual).should be_an_instance_of(URI::HTTP)
  end
end
