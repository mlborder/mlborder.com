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

ActiveRecord::Schema.define(version: 20160108093450) do

  create_table "alarms", force: :cascade do |t|
    t.integer  "event_id",               null: false
    t.integer  "user_id",                null: false
    t.integer  "status",     default: 0, null: false
    t.integer  "target",                 null: false
    t.integer  "rank",                   null: false
    t.decimal  "value",                  null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "event_final_borders", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "rank",       default: 1200, null: false
    t.integer  "point",                     null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "event_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer  "event_type_id",     limit: 4
    t.string   "name",              limit: 255,                 null: false
    t.integer  "event_type",        limit: 4,   default: 0
    t.string   "series_name",       limit: 255
    t.datetime "started_at",                                    null: false
    t.datetime "ended_at",                                      null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.boolean  "records_available",             default: false, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider",                null: false
    t.string   "uid",                     null: false
    t.string   "screen_name",             null: false
    t.string   "name",                    null: false
    t.integer  "role",        default: 0, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

end
