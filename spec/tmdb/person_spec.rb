require 'spec_helper'

module TMDb
  describe Person do
    subject { Person.new("id" => 123, "name" => "Keanu Reeves") }
    its(:id) { should == 123 }
    its(:name) { should == "Keanu Reeves" }
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
  end
end
