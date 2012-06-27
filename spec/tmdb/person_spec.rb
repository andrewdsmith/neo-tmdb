require 'spec_helper'

module TMDb
  describe Person do
    context "when created with all attributes populated" do
      subject do
        # JSON sample from http://help.themoviedb.org/kb/api/person-info.
        Person.new(JSON.parse('{
          "adult": false,
          "also_known_as": [],
          "biography": "From Wikipedia, the free encyclopedia...",
          "birthday": "1963-12-18",
          "deathday": "",
          "homepage": "http://simplybrad.com/",
          "id": 287,
          "name": "Brad Pitt",
          "place_of_birth": "Shawnee, Oklahoma, United States",
          "profile_path": "/w8zJQuN7tzlm6FY9mfGKihxp3Cb.jpg"
        }'))
      end
      its(:adult) { should == false }
      its(:also_known_as) { should == [] }
      its(:biography) { should == "From Wikipedia, the free encyclopedia..." }
      its(:birthday) { should == "1963-12-18" }
      its(:deathday) { should == "" }
      its(:homepage) { should == "http://simplybrad.com/" }
      its(:id) { should == 287 }
      its(:name) { should == "Brad Pitt" }
      its(:place_of_birth) { should == "Shawnee, Oklahoma, United States" }
      its(:profile_path) { should == "/w8zJQuN7tzlm6FY9mfGKihxp3Cb.jpg" }
    end

    describe ".find" do
      let(:person) { Person.find(find_args) }
      context "when passed an integer", :vcr => { :cassette_name => "person_find_keanu_by_id" } do
        let(:find_args) { 6384 }
        it "returns a Person object" do
          person.should be_a(Person)
        end
        it "returns the person matching the TMDb person id" do
          person.id.should == find_args
          person.name.should == "Keanu Reeves"
        end
      end
    end

    describe ".where" do
      let(:people) { Person.where(where_args) }
      context "when passed :name", :vcr => { :cassette_name => "person_where_name" } do
        let(:search_term) { "Reeves" }
        let(:where_args) { { :name => search_term } }
        it "returns an enumerable" do
          people.should have_at_least(1).person
        end
        it "returns Person objects in the enumerable" do
          people.each {|person| person.should be_a(Person) }
        end
        it "returns only people matching the given name" do
          people.each {|person| person.name.should include(search_term) }
        end
        it "returns everyone with their id set" do
          people.each {|person| person.id.should be_a(Fixnum) }
        end
      end
    end

    describe "#profile_image_url", :vcr => { :cassette_name => "person_find_keanu_by_id" } do
      let(:person) { Person.find(6384) }
      let(:example_base_url) { 'http://example.com/path/' }

      it 'returns a full URL based on the configuration and profile path' do
        TMDb.configuration.stub(:image_base_url) { example_base_url }
        person.profile_image_url(:my_image_size).should ==
          "#{example_base_url}my_image_size/jmjeALlAVaPB8SonLR3qBN5myjc.jpg"
      end

      context 'when the profile path is nil', :vcr => { :cassette_name => 'person_find_no_profile_path' } do
        let(:person) { Person.find(93322) }
        it 'returns nil' do
          person.profile_image_url(:my_image_size).should be_nil
        end
      end
    end
  end
end
