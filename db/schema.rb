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

ActiveRecord::Schema.define(version: 20130718111037) do

  create_table "snapshots", force: true do |t|
    t.string   "url"
    t.integer  "tweet_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tweets", force: true do |t|
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "coordinates",            limit: {:srid=>3785, :type=>"point"}
    t.spatial  "geographic_coordinates", limit: {:srid=>4326, :type=>"point", :geographic=>true}
  end

  add_index "tweets", ["coordinates"], :name => "index_tweets_on_coordinates", :spatial => true
  add_index "tweets", ["created_at"], :name => "index_tweets_on_created_at"

end
