require 'spec_helper'

module TMDb
  describe NullPerson do
    its(:adult) { should be_nil }
    its(:also_known_as) { should be_nil }
    its(:biography) { should be_nil }
    its(:birthday) { should be_nil }
    its(:deathday) { should be_nil }
    its(:homepage) { should be_nil }
    its(:id) { should be_nil }
    its(:name) { should be_nil }
    its(:place_of_birth) { should be_nil }
    its(:profile_path) { should be_nil }

    describe "#profile_image_url" do
      it "returns nil by default" do
        subject.profile_image_url(:anything).should be_nil
      end
    end

    describe "#profile_image_url=" do
      it "acts as an attribute writer" do
        subject.profile_image_url = :set_value
        subject.profile_image_url(anything).should == :set_value
      end
    end
  end
end
