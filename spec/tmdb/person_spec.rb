require 'spec_helper'

module TMDb
  describe Person do
    let(:api_response) { 'An example API response' }
    before(:each) do
      TMDb.stub(:get_api_response) { api_response }
    end

    context 'when created with all attributes populated' do
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
      its(:biography) { should == 'From Wikipedia, the free encyclopedia...' }
      its(:birthday) { should == '1963-12-18' }
      its(:deathday) { should == '' }
      its(:homepage) { should == 'http://simplybrad.com/' }
      its(:id) { should == 287 }
      its(:name) { should == 'Brad Pitt' }
      its(:place_of_birth) { should == 'Shawnee, Oklahoma, United States' }
      its(:profile_path) { should == '/w8zJQuN7tzlm6FY9mfGKihxp3Cb.jpg' }
    end

    describe '.find' do
      let(:id) { 123 }
      let(:new_person) { mock(Person) }
      before(:each) do
        Person.stub(:new) { new_person }
      end

      it 'makes an API request to "person/{id}"' do
        TMDb.should_receive(:get_api_response).with("person/#{id}")
        Person.find(id)
      end
      it 'constructs a new Person object with the API response' do
        Person.should_receive(:new).with(api_response)
        Person.find(id)
      end
      it 'returns the new Person object' do
        Person.find(id).should be(new_person)
      end

      context 'when the TMDb service is unavailable' do
        before(:each) do
          TMDb.configure {|c| c.null_person = null_person }
          TMDb.stub(:get_api_response) { raise TMDb::ServiceUnavailable }
        end

        context 'when configured to return a null object' do
          let(:null_person) { mock(NullPerson) }

          it 'returns a NullPerson object' do
            Person.find(id).should be(null_person)
          end
        end

        context 'when not configured to return a null object' do
          let(:null_person) { nil }

          it 'raises a TMDb::ServiceUnavailable error' do
            expect { Person.find(id) }.to raise_error(TMDb::ServiceUnavailable)
          end
        end
      end
    end

    describe '.where' do
      context 'when passed :name' do
        let(:name) { 'bob' }
        let(:api_response) { { 'results' => results } }
        let(:results) { ['a', 'b', 'c'] }
        let(:new_people) { (1..3).map { mock(Person) } }
        before(:each) do
          Person.stub(:new).and_return(*new_people)
        end

        it 'makes an API request to "search/person" with the name as query' do
          TMDb.should_receive(:get_api_response).with('search/person', :query => name)
          Person.where(:name => name)
        end
        it 'constructs a new Person object for each result in the API response' do
          results.each do |result|
            Person.should_receive(:new).with(result)
          end
          Person.where(:name => name)
        end
        it 'returns an Enumerable containing the new Person objects' do
          Person.where(:name => name).should == new_people
        end
      end
    end

    describe '#profile_image_url' do
      let(:person) { Person.new('profile_path' => profile_path) }
      let(:profile_path) { '/profile_path.jpg' }
      let(:image_base_url) { 'http://example.com/images/' }
      before(:each) do
        TMDb.configuration.stub(:image_base_url) { image_base_url }
      end

      it 'returns a full URL based on the configuration and profile path' do
        person.profile_image_url(:example_image_size).should ==
          [image_base_url, :example_image_size, profile_path].join
      end

      context 'when the person has no profile path' do
        let(:profile_path) { nil }

        it 'returns nil' do
          person.profile_image_url(:example_image_size).should be_nil
        end
      end
    end
  end
end
