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

ActiveRecord::Schema.define(version: 20150920155959) do

  create_table "comments", force: true do |t|
    t.string   "user_id",    null: false
    t.string   "post_id",    null: false
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["user_id", "post_id"], name: "index_comments_on_user_id_and_post_id", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "involvements", force: true do |t|
    t.string "user_id"
    t.string "organization_id"
  end

  create_table "like_comments", force: true do |t|
    t.string "user_id",    null: false
    t.string "comment_id", null: false
  end

  create_table "likes", force: true do |t|
    t.string   "post_id",    null: false
    t.string   "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "link_comments", force: true do |t|
    t.text     "content"
    t.integer  "point",      default: 0
    t.integer  "link_id"
    t.string   "user_id",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "link_comments", ["link_id"], name: "index_link_comments_on_link_id", using: :btree

  create_table "link_stats", force: true do |t|
    t.string   "url"
    t.integer  "clicked_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "url"
    t.integer  "point",       default: 0
    t.string   "user_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.string   "from_user"
    t.string   "to_user"
    t.integer  "action",     limit: 1
    t.string   "meta"
    t.string   "endpoint"
    t.integer  "status",     limit: 1, default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["from_user", "to_user", "action"], name: "index_notifications_on_from_user_and_to_user_and_action", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name",       null: false
    t.text     "info"
    t.string   "place"
    t.string   "homepage"
    t.string   "avatar_url"
    t.string   "cover_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "user_id",                              null: false
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",     limit: 1,  default: 0
    t.string   "slug"
    t.float    "score",      limit: 53, default: -1.0
  end

  add_index "posts", ["status"], name: "index_posts_on_status", using: :btree

  create_table "project_posts", force: true do |t|
    t.integer "project_id"
    t.string  "post_id"
  end

  add_index "project_posts", ["project_id", "post_id"], name: "index_project_posts_on_project_id_and_post_id", using: :btree

  create_table "project_users", force: true do |t|
    t.integer "project_id"
    t.string  "user_id"
  end

  add_index "project_users", ["project_id", "user_id"], name: "index_project_users_on_project_id_and_user_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "avatar"
    t.string   "url"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quotes", force: true do |t|
    t.text     "content",    null: false
    t.text     "author",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.string   "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.integer  "taggings_count", default: 0
    t.string   "color_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_path",     default: "/assets/tags/default-499574ee87d431f87c234a7c4da533a5.png"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "user_relationships", force: true do |t|
    t.string   "follower_id", null: false
    t.string   "followed_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_relationships", ["followed_id"], name: "index_user_relationships_on_followed_id", using: :btree
  add_index "user_relationships", ["follower_id", "followed_id"], name: "index_user_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "user_relationships", ["follower_id"], name: "index_user_relationships_on_follower_id", using: :btree

  create_table "user_tags", force: true do |t|
    t.string   "user_id",    null: false
    t.integer  "tag_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_tags", ["user_id", "tag_id"], name: "index_user_tags_on_user_id_and_tag_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                             default: "",   null: false
    t.string   "encrypted_password",                default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "avatar_url"
    t.string   "locale",                            default: "vi", null: false
    t.string   "github_url"
    t.string   "twitter_url"
    t.string   "facebook_url"
    t.string   "handle_name",            limit: 50
    t.float    "score_periodic",         limit: 53, default: -1.0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["handle_name"], name: "index_users_on_handle_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.integer  "link_id"
    t.string   "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["link_id"], name: "index_votes_on_link_id", using: :btree

  create_table "watchings", force: true do |t|
    t.string "user_id"
    t.string "organization_id"
  end

  add_index "watchings", ["user_id", "organization_id"], name: "index_watchings_on_user_id_and_organization_id", using: :btree

end
