require 'spec_helper'

describe Tweet do
  describe ".create_from_tweet" do
    context "without coordinates or a place" do

    end

    context "without coordinates but with a place" do
      let(:tweet_json) do
        {
          "created_at"=>"Mon May 11 20:26:24 +0000 2015",
          "id"=>597860328605618178,
          "id_str"=>"597860328605618178",
          "text"=>"RT @marcokanobelj=>Luned\u00ec 11 Maggio, Buongiorno!!! http:\/\/t.co\/R6RNnJWeXS",
          "geo"=>nil,
          "coordinates"=>nil,
          "user"=>{ "screen_name"=>"yolo88"},
          "place"=>{
            "id"=>"9df3d1b39e7c078d",
            "url"=>"https:\/\/api.twitter.com\/1.1\/geo\/id\/9df3d1b39e7c078d.json",
            "place_type"=>"poi", # Intentionally made poi, ignore the other things but bounding box
            "name"=>"Genoa",
            "full_name"=>"Genoa, Liguria",
            "country_code"=>"IT",
            "country"=>"Italia",
            "bounding_box"=>{
              "type"=>"Polygon",
              "coordinates"=>[
                [
                  [8.6658519, 44.3790834],
                  [8.6658519, 44.5199153],
                  [9.0958379, 44.5199153],
                  [9.0958379, 44.3790834]
                ]
              ]
            },
            "attributes"=>{}
          },
          "contributors"=>nil,
        }
      end

      it "should record the location" do
        expect {
          Tweet.create_from_tweet tweet_json
        }.to change { Tweet.count }.by(1)

        tweet = Tweet.last
        tweet.coordinates.should be
      end
    end
  end
end

