require 'spec_helper'

describe Neighborhood do
  describe "factories" do
    context "standard" do
      it "should create a valid neighborhood" do
        FactoryGirl.create(:neighborhood).should be_valid
      end
    end
  end
end
