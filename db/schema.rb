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

ActiveRecord::Schema.define(:version => 20130327152341) do

  create_table "buzz_mention_highlights", :force => true do |t|
    t.integer  "buzz_mention_id"
    t.text     "buzz_mention_highlight_text"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "buzz_mentions", :force => true do |t|
    t.decimal  "buzz_score"
    t.integer  "buzz_post_id"
    t.integer  "restaurant_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.decimal  "decayed_buzz_score"
  end

  create_table "buzz_posts", :force => true do |t|
    t.datetime "post_date_time"
    t.text     "post_uri"
    t.text     "post_content"
    t.boolean  "scanned_flag"
    t.decimal  "post_weight"
    t.integer  "buzz_source_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "post_guid"
    t.string   "post_title"
  end

  create_table "buzz_sources", :force => true do |t|
    t.string   "name"
    t.string   "uri"
    t.decimal  "buzz_weight"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "source_id_tag"
    t.integer  "city_id"
    t.integer  "buzz_source_type_id"
    t.string   "x_path_nodes"
    t.string   "buzz_source_type"
    t.string   "city",                :default => "nyc"
    t.decimal  "decay_factor",        :default => 0.906
  end

  create_table "pg_search_documents", :force => true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "restaurants", :force => true do |t|
    t.string   "name"
    t.string   "style"
    t.integer  "weeks_on_list"
    t.string   "neighborhood"
    t.string   "reserve"
    t.text     "description"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "twitter_handle"
    t.boolean  "exact_match"
    t.boolean  "skip_scan"
    t.integer  "city_id"
    t.integer  "buzz_mentions_count", :default => 0
    t.string   "city",                :default => "nyc"
    t.decimal  "total_current_buzz",  :default => 0.0
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "auth_token"
    t.string   "role"
  end

end
