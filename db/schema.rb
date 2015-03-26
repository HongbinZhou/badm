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

ActiveRecord::Schema.define(version: 20150326082211) do

  create_table "costs", force: true do |t|
    t.float    "money"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
    t.integer  "event_id"
    t.integer  "att_nr"
  end

  create_table "events", force: true do |t|
    t.date     "date"
    t.string   "place"
    t.float    "cost_total"
    t.float    "cost_per_person"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payer_id"
    t.integer  "att_nr"
  end

  create_table "events_people", id: false, force: true do |t|
    t.integer "event_id"
    t.integer "person_id"
    t.integer "friends_number"
  end

  add_index "events_people", ["event_id", "person_id"], name: "events_people_index", unique: true

  create_table "people", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.float    "money"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
