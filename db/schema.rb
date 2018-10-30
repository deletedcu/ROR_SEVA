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

ActiveRecord::Schema.define(version: 20160824063507) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
    t.index ["user_id"], name: "index_impressions_on_user_id", using: :btree
  end

  create_table "leads", force: :cascade do |t|
    t.string   "player_name"
    t.string   "coach_name"
    t.string   "coach_email"
    t.string   "user_email"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "user_name"
  end

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.string   "st"
    t.string   "committed_to",             default: "Undeclared"
    t.string   "high_school"
    t.string   "height"
    t.string   "position"
    t.string   "style"
    t.string   "grad_year"
    t.boolean  "current",                  default: true,         null: false
    t.string   "school_class"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "slug"
    t.boolean  "verified"
    t.integer  "verified_by"
    t.integer  "submitted_by"
    t.integer  "last_edited_by"
    t.integer  "impressions_count"
    t.integer  "weekly_impressions_count", default: 0
    t.integer  "trending_rank",            default: 0
    t.index ["slug"], name: "index_players_on_slug", unique: true, using: :btree
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "espn",       default: 0
    t.integer  "scout",      default: 0
    t.integer  "rivals",     default: 0
    t.integer  "player_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "similars", force: :cascade do |t|
    t.integer  "player_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "similar_name"
  end

  create_table "skills", force: :cascade do |t|
    t.float    "seva_win",   default: 0.0
    t.float    "seva_ppg",   default: 0.0
    t.float    "seva_apg",   default: 0.0
    t.float    "seva_rpg",   default: 0.0
    t.float    "seva_spg",   default: 0.0
    t.float    "seva_bpg",   default: 0.0
    t.float    "seva_fg",    default: 0.0
    t.integer  "player_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "stats", force: :cascade do |t|
    t.float    "seva_score",   default: 0.0
    t.float    "ppg",          default: 0.0
    t.float    "apg",          default: 0.0
    t.float    "rpg",          default: 0.0
    t.float    "bpg",          default: 0.0
    t.float    "spg",          default: 0.0
    t.integer  "fg",           default: 0
    t.integer  "games_played", default: 0
    t.integer  "winp",         default: 0
    t.integer  "season"
    t.string   "hs_level",     default: "NA"
    t.string   "year",         default: "NA"
    t.integer  "player_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "seva_scout",             default: false, null: false
    t.string   "school"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "stripe_id"
    t.string   "stripe_subscription_id"
    t.string   "card_last4"
    t.string   "card_type"
    t.integer  "card_exp_month"
    t.integer  "card_exp_year"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
