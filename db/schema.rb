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

ActiveRecord::Schema.define(version: 20160420093514) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "name",             limit: 60
    t.integer  "suggested_amount"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "balances", force: :cascade do |t|
    t.string   "name"
    t.integer  "amount"
    t.boolean  "current",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "goals", force: :cascade do |t|
    t.string   "name",        limit: 32
    t.integer  "amount"
    t.date     "achieved_on"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "balance_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.integer  "activity_id"
    t.integer  "balance_id"
    t.integer  "amount"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
