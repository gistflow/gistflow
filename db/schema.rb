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

ActiveRecord::Schema.define(:version => 20120304144030) do

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

  create_table "comments", :force => true do |t|
    t.boolean   "question",    :default => false
    t.text      "content"
    t.integer   "user_id"
    t.integer   "post_id"
    t.integer   "likes_count", :default => 0
    t.timestamp "created_at",                     :null => false
    t.timestamp "updated_at",                     :null => false
  end

  create_table "favorite_posts_lovers", :id => false, :force => true do |t|
    t.integer "post_id"
    t.integer "user_id"
  end

  add_index "favorite_posts_lovers", ["post_id", "user_id"], :name => "index_favorite_posts_lovers_on_post_id_and_user_id", :unique => true

  create_table "frameworks", :force => true do |t|
    t.string   "name"
    t.integer  "language_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "gists", :force => true do |t|
    t.integer "user_id"
    t.integer "source_id"
    t.string  "source_type"
    t.integer "github_id"
  end

  create_table "kits", :force => true do |t|
    t.string  "name"
    t.integer "position",       :default => 0
    t.integer "group_position"
    t.integer "tags_count",     :default => 0
  end

  add_index "kits", ["group_position", "position"], :name => "index_kits_on_group_position_and_position", :unique => true

  create_table "kits_tags", :id => false, :force => true do |t|
    t.integer "kit_id"
    t.integer "tag_id"
  end

  add_index "kits_tags", ["kit_id", "tag_id"], :name => "index_kits_tags_on_kit_id_and_tag_id", :unique => true
  add_index "kits_tags", ["kit_id"], :name => "index_kits_tags_on_kit_id"
  add_index "kits_tags", ["tag_id"], :name => "index_kits_tags_on_tag_id"

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "likes", :force => true do |t|
    t.integer   "user_id"
    t.integer   "likable_id"
    t.string    "likable_type"
    t.timestamp "created_at",   :null => false
    t.timestamp "updated_at",   :null => false
  end

  add_index "likes", ["user_id", "likable_id", "likable_type"], :name => "index_likes_on_user_id_and_likable_id_and_likable_type", :unique => true

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.boolean  "read",            :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "notifications", ["user_id", "notifiable_id", "notifiable_type"], :name => "notifications_users_notifiables", :unique => true

  create_table "posts", :force => true do |t|
    t.integer   "comments_count", :default => 0
    t.integer   "likes_count",    :default => 0
    t.text      "content"
    t.integer   "state_id"
    t.integer   "user_id"
    t.string    "type"
    t.timestamp "created_at",                    :null => false
    t.timestamp "updated_at",                    :null => false
  end

  create_table "posts_tags", :id => false, :force => true do |t|
    t.integer "post_id"
    t.integer "tag_id"
  end

  add_index "posts_tags", ["post_id", "tag_id"], :name => "index_posts_tags_on_post_id_and_tag_id", :unique => true

  create_table "subscriptions", :force => true do |t|
    t.integer "user_id"
    t.integer "tag_id"
  end

  add_index "subscriptions", ["tag_id", "user_id"], :name => "index_subscriptions_on_tag_id_and_user_id", :unique => true

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "posts_count", :default => 0
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "user_kits", :force => true do |t|
    t.integer "user_id"
    t.integer "kit_id"
  end

  add_index "user_kits", ["user_id", "kit_id"], :name => "index_user_kits_on_user_id_and_kit_id", :unique => true
  add_index "user_kits", ["user_id"], :name => "index_user_kits_on_user_id"

  create_table "users", :force => true do |t|
    t.string    "username"
    t.string    "name"
    t.string    "email"
    t.string    "home_page"
    t.string    "github_page"
    t.string    "gravatar_id"
    t.timestamp "created_at"
  end

  create_table "users_kits", :force => true do |t|
    t.integer "user_id"
    t.integer "kit_id"
  end

  add_index "users_kits", ["user_id", "kit_id"], :name => "index_users_kits_on_user_id_and_kit_id", :unique => true
  add_index "users_kits", ["user_id"], :name => "index_users_kits_on_user_id"

end
