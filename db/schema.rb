# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150513153232) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_topology"

  create_table "hashtag_analytics", force: true do |t|
    t.string   "period"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "neighborhood_id"
    t.string   "borough"
  end

  create_table "hashtag_analytics_entries", force: true do |t|
    t.integer "hashtag_analytics_id"
    t.string  "term"
    t.integer "count"
  end

  add_index "hashtag_analytics_entries", ["hashtag_analytics_id"], :name => "index_hashtag_analytics_entries_on_hashtag_analytics_id"

  create_table "hashtags", force: true do |t|
    t.integer  "tweet_id"
    t.string   "term"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "neighborhood_id"
    t.string   "borough"
  end

  add_index "hashtags", ["created_at"], :name => "index_hashtags_on_created_at"
  add_index "hashtags", ["neighborhood_id"], :name => "index_hashtags_on_neighborhood_id"
  add_index "hashtags", ["term"], :name => "index_hashtags_on_term"
  add_index "hashtags", ["tweet_id"], :name => "index_hashtags_on_tweet_id"

  create_table "neighborhoods", force: true do |t|
    t.string   "name",                                                null: false
    t.string   "slug"
    t.string   "borough",                                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "geometry",   limit: {:srid=>3785, :type=>"geometry"}
  end

  add_index "neighborhoods", ["slug"], :name => "index_neighborhoods_on_slug", :unique => true

  create_table "snapshots", force: true do |t|
    t.string   "url"
    t.integer  "tweet_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "begins_at"
    t.datetime "ends_at"
    t.string   "area"
  end

  create_table "tweets", force: true do |t|
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "coordinates",            limit: {:srid=>3785, :type=>"point"}
    t.spatial  "geographic_coordinates", limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.string   "media_url"
    t.string   "media_type"
    t.string   "hashtags"
    t.integer  "neighborhood_id"
    t.string   "screen_name"
    t.string   "profile_image_url"
    t.boolean  "poi",                                                                             default: false, null: false
  end

  add_index "tweets", ["coordinates"], :name => "index_tweets_on_coordinates", :spatial => true
  add_index "tweets", ["created_at"], :name => "index_tweets_on_created_at"
  add_index "tweets", ["neighborhood_id"], :name => "index_tweets_on_neighborhood_id"

end
