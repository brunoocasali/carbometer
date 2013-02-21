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

ActiveRecord::Schema.define(:version => 20130220230803) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "posts", :force => true do |t|
    t.string   "title",                        :null => false
    t.string   "path",         :limit => 1024, :null => false
    t.integer  "user_id"
    t.datetime "published_at"
  end

  add_index "posts", ["path"], :name => "index_posts_on_path"
  add_index "posts", ["title"], :name => "index_posts_on_title"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "statistics", :force => true do |t|
    t.integer "post_id"
    t.string  "source",      :null => false
    t.date    "start_date",  :null => false
    t.date    "end_date",    :null => false
    t.integer "visit_count"
  end

  add_index "statistics", ["post_id", "source", "start_date", "end_date"], :name => "unique_statistic", :unique => true
  add_index "statistics", ["post_id"], :name => "index_statistics_on_post_id"

  create_table "users", :force => true do |t|
    t.string "name"
    t.string "email"
  end

  add_index "users", ["name"], :name => "index_users_on_name"

end
