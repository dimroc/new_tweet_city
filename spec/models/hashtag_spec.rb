require 'spec_helper'

describe Hashtag do
  describe ".create_from_tweet" do
    let(:tweet) do
      FactoryGirl.create(:tweet,
                         neighborhood: Neighborhood.brooklyn.first,
                         hashtags: "this,is,all,of,them"
                        )
    end

    before do
      NeighborhoodFactory.from_shapefile(
        File.join(Rails.root, "lib/data/shapefiles/neighborhoods/neighborhood"))
    end

    it "should create all hashtags" do
      expect {
        Hashtag.create_from_tweet(tweet)
      }.to change { Hashtag.count }.by(5)

      ht = Hashtag.last
      ht.tweet_id.should == tweet.id
      ht.neighborhood_id.should == tweet.neighborhood_id
      ht.borough.should == "Brooklyn"

      Hashtag.last(5).map(&:term).should == ["this", "is", "all", "of", "them"]
    end
  end
end
