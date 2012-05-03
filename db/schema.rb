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

ActiveRecord::Schema.define(:version => 20120430200525) do

  create_table "account_cookies", :force => true do |t|
    t.string  "secret"
    t.integer "user_id"
  end

  add_index "account_cookies", ["secret"], :name => "index_account_cookies_on_secret", :unique => true

  create_table "account_githubs", :force => true do |t|
    t.string  "token"
    t.integer "github_id"
    t.integer "user_id"
  end

  add_index "account_githubs", ["github_id"], :name => "index_account_githubs_on_github_id", :unique => true
  add_index "account_githubs", ["token"], :name => "index_account_githubs_on_token", :unique => true

  create_table "account_twitters", :force => true do |t|
    t.integer "user_id"
    t.integer "twitter_id"
    t.string  "token"
    t.string  "secret"
  end

  add_index "account_twitters", ["user_id"], :name => "index_account_twitters_on_user_id", :unique => true

  create_table "comments", :force => true do |t|
    t.boolean  "question",    :default => false
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "likes_count", :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "followings", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "followings", ["followed_user_id", "follower_id"], :name => "index_followings_on_followed_user_id_and_follower_id", :unique => true
  add_index "followings", ["followed_user_id"], :name => "index_followings_on_followed_user_id"
  add_index "followings", ["follower_id"], :name => "index_followings_on_follower_id"

  create_table "gists", :force => true do |t|
    t.integer "user_id"
    t.integer "source_id"
    t.string  "source_type"
    t.integer "github_id"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.boolean  "read",            :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "type"
  end

  add_index "notifications", ["user_id", "notifiable_id", "notifiable_type", "type"], :name => "notifications_users_notifiables", :unique => true

  create_table "observings", :force => true do |t|
    t.integer "post_id"
    t.integer "user_id"
  end

  add_index "observings", ["post_id", "user_id"], :name => "index_observings_on_post_id_and_user_id", :unique => true
  add_index "observings", ["post_id"], :name => "index_observings_on_post_id"
  add_index "observings", ["user_id"], :name => "index_observings_on_user_id"

  create_table "posts", :force => true do |t|
    t.integer  "comments_count", :default => 0
    t.integer  "likes_count",    :default => 0
    t.string   "title"
    t.text     "content"
    t.integer  "state_id"
    t.integer  "user_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "question",       :default => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer "user_id"
    t.integer "tag_id"
  end

  add_index "subscriptions", ["tag_id", "user_id"], :name => "index_subscriptions_on_tag_id_and_user_id", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer "taggable_id"
    t.string  "taggable_type"
    t.integer "tag_id"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_type", "taggable_id", "tag_id"], :name => "index_taggings_on_taggable_type_and_taggable_id_and_tag_id", :unique => true
  add_index "taggings", ["taggable_type", "taggable_id"], :name => "index_taggings_on_taggable_type_and_taggable_id"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "taggings_count", :default => 0
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "name"
    t.string   "email"
    t.string   "home_page"
    t.string   "github_page"
    t.string   "gravatar_id"
    t.datetime "created_at"
    t.string   "company"
  end

end
