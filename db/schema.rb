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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130617235740) do

  create_table "activities", :force => true do |t|
    t.integer  "category_id"
    t.integer  "user_id"
    t.string   "extern_id"
    t.string   "title"
    t.text     "description"
    t.string   "phone"
    t.string   "creator"
    t.float    "lat"
    t.float    "long"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.float    "duration"
    t.string   "venue_name"
    t.string   "street"
    t.string   "city"
    t.integer  "zip"
    t.string   "recurrence"
    t.string   "url"
    t.string   "image_url"
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
    t.integer  "times_visited",                                    :default => 0
    t.string   "dup_status",                                       :default => "No"
    t.decimal  "min_price",         :precision => 10, :scale => 2
    t.decimal  "max_price",         :precision => 10, :scale => 2
    t.integer  "country_id"
    t.integer  "region_id"
    t.string   "url_slug"
    t.text     "title_words"
    t.text     "description_words"
  end

  add_index "activities", ["ends_at", "country_id"], :name => "index_activities_on_ends_at_and_country_id"
  add_index "activities", ["starts_at", "ends_at", "country_id"], :name => "index_activities_on_starts_at_and_ends_at_and_country_id"

  create_table "categories", :force => true do |t|
    t.string "name"
    t.string "video_url"
    t.string "image_url"
    t.text   "description"
    t.string "url_slug"
  end

  create_table "countries", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "regions", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "words", :force => true do |t|
    t.string  "word"
    t.string  "wordable_type"
    t.string  "interpretation"
    t.integer "wordable_id"
    t.integer "counter"
  end

end
