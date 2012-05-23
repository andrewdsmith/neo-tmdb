require 'spec_helper'

describe TMDb do
  describe ".configuration" do
    it "returns a TMDb::Configuration object" do
      TMDb.configuration.should be_a(TMDb::Configuration)
    end
    it "returns the same object each time" do
      TMDb.configuration.should be(TMDb.configuration)
    end
  end
  describe ".configure" do
    it "yields the configuration" do
      pending do
        expect {|blk| TMDb.configure(&blk) }.to yield_with_args(TMDb.configuration)
      end
    end
  end
end
