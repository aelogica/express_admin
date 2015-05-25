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

ActiveRecord::Schema.define(version: 20150525221228) do

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "express_admin_settings", force: :cascade do |t|
    t.string "setting"
    t.string "value"
    t.string "type"
  end

  create_table "widgets", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "column2"
    t.text     "column3"
    t.datetime "column4"
    t.boolean  "column5"
    t.string   "column6"
    t.integer  "column7"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
