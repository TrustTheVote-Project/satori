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

ActiveRecord::Schema.define(version: 20150710071410) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer  "state_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "website"
    t.boolean  "suspended",  default: false, null: false
  end

  add_index "accounts", ["name"], name: "index_accounts_on_name", unique: true, using: :btree
  add_index "accounts", ["state_id"], name: "index_accounts_on_state_id", using: :btree
  add_index "accounts", ["suspended"], name: "index_accounts_on_suspended", using: :btree

  create_table "elections", force: :cascade do |t|
    t.string   "name"
    t.date     "held_on"
    t.date     "voter_start_on"
    t.date     "voter_end_on"
    t.date     "reg_deadline_on"
    t.date     "ab_req_deadline_on"
    t.date     "ab_rec_deadline_on"
    t.date     "ffd_deadline_on"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "logs", force: :cascade do |t|
    t.integer  "election_id"
    t.string   "origin",                    null: false
    t.string   "origin_uniq"
    t.datetime "create_date",               null: false
    t.string   "hash_alg",                  null: false
    t.string   "filename"
    t.integer  "records_count", default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "logs", ["election_id"], name: "index_logs_on_election_id", using: :btree

  create_table "records", force: :cascade do |t|
    t.integer  "log_id"
    t.string   "voter_id",     null: false
    t.datetime "recorded_at",  null: false
    t.string   "action",       null: false
    t.string   "jurisdiction", null: false
    t.string   "form"
    t.string   "form_note"
    t.string   "leo"
    t.string   "notes"
    t.string   "comment"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "records", ["log_id"], name: "index_records_on_log_id", using: :btree

  create_table "registration_requests", force: :cascade do |t|
    t.string   "organization_name",                 null: false
    t.string   "state",                             null: false
    t.string   "website"
    t.string   "admin_title",                       null: false
    t.string   "admin_email",                       null: false
    t.string   "admin_phone"
    t.boolean  "archived",          default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "admin_first_name"
    t.string   "admin_last_name"
    t.boolean  "rejected",          default: false, null: false
  end

  add_index "registration_requests", ["archived"], name: "index_registration_requests_on_archived", using: :btree
  add_index "registration_requests", ["rejected"], name: "index_registration_requests_on_rejected", using: :btree

  create_table "states", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
  end

  create_table "tenet_settings", force: :cascade do |t|
    t.string   "name",       null: false
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tenet_settings", ["name"], name: "index_tenet_settings_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "account_id",                                      null: false
    t.string   "login",                                           null: false
    t.string   "crypted_password",                                null: false
    t.string   "salt",                                            null: false
    t.string   "first_name",                                      null: false
    t.string   "last_name",                                       null: false
    t.string   "email",                                           null: false
    t.boolean  "admin",                           default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "phone"
    t.string   "title"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.boolean  "password_set",                    default: false, null: false
    t.string   "last_login_from_ip_address"
    t.string   "role"
    t.text     "ssh_public_key"
    t.boolean  "suspended",                       default: false, null: false
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id", using: :btree
  add_index "users", ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at", using: :btree
  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree
  add_index "users", ["ssh_public_key"], name: "index_users_on_ssh_public_key", unique: true, using: :btree
  add_index "users", ["suspended"], name: "index_users_on_suspended", using: :btree

  add_foreign_key "logs", "elections"
  add_foreign_key "records", "logs"
end
