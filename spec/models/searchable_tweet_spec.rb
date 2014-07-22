require 'spec_helper'

describe SearchableTweet do
  before :each do
    Tweet.__elasticsearch__.delete_index! rescue nil
    Tweet.__elasticsearch__.create_index!
  end

  describe ".fast_import" do
    def create_tweets_without_import
      # Factories don't create tweets anyways because the commit never occurs, we're in a transaction.
      FactoryGirl.create_list(:tweet, 3)
    end

    it "should import the tweets" do
      sleep 1
      Tweet.__elasticsearch__.client.count(index: "tweets-test")["count"].should == 0
      create_tweets_without_import
      Tweet.fast_import
      Tweet.__elasticsearch__.refresh_index!
      Tweet.__elasticsearch__.client.count(index: "tweets-test")["count"].should == 3
    end
  end

  describe "with indexed tweets" do
    let(:east_village) { FactoryGirl.create(:neighborhood, borough: "Manhattan", name: "East Village") }
    let(:williamsburg) { FactoryGirl.create(:neighborhood, borough: "Brooklyn", name: "Williamsburg") }

    let!(:manhattan_tweet) { FactoryGirl.create(:tweet, text: "same words", neighborhood: east_village) }
    let!(:brooklyn_tweet) { FactoryGirl.create(:tweet, text: "same words", neighborhood: williamsburg) }

    before do
      Tweet.fast_import
      Tweet.__elasticsearch__.refresh_index!
    end

    describe ".search_count_in" do
      it "should return the correct count" do
        Tweet.search_count_in("manhattan", "same")["east-village"].should == 1
      end
    end

    describe ".search_count_by_location" do
      it "should return the correct count" do
        rval = Tweet.search_count_by_location("same")
        rval.Brooklyn.neighborhoods.williamsburg.should == 1
        rval.Manhattan.neighborhoods["east-village"].should == 1
      end
    end

    describe ".search_count_in_hoods" do
      it "should return the correct count" do
        rval = Tweet.search_count_in_hoods("same")
        rval["east-village"].should == 1
        rval["williamsburg"].should == 1
      end
    end

    describe ".search_count_in_boroughs" do
      it "should return the correct count" do
        rval = Tweet.search_count_in_boroughs("same")
        rval["Manhattan"].should == 1
        rval["Brooklyn"].should == 1
      end
    end
  end
end
