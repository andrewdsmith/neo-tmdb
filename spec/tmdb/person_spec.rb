require 'spec_helper'

module TMDb
  describe Person do
    subject { Person.new("id" => 123, "name" => "Keanu Reeves") }
    its(:id) { should == 123 }
    its(:name) { should == "Keanu Reeves" }
    describe ".where" do
      let(:people) { Person.where(where_args) }
      context "when passed :name" do
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
