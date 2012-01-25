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

ActiveRecord::Schema.define(:version => 20120125165831) do

  create_table "account_cookies", :force => true do |t|
    t.string  "secret"
    t.integer "user_id"
  end

  add_index "account_cookies", ["secret"], :name => "index_account_cookies_on_secret", :unique => true

  create_table "account_githubs", :force => true do |t|
    t.string  "token"
    t.integer "user_id"
  end

  add_index "account_githubs", ["token"], :name => "index_account_githubs_on_token", :unique => true

  create_table "comments", :force => true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "gists", :force => true do |t|
    t.integer "user_id"
    t.integer "source_id"
    t.string  "source_type"
    t.integer "github_id"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "state"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts_tags", :id => false, :force => true do |t|
    t.integer "post_id"
    t.integer "tag_id"
  end

  add_index "posts_tags", ["post_id", "tag_id"], :name => "index_posts_tags_on_post_id_and_tag_id", :unique => true

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "username"
    t.datetime "created_at"
  end

end
