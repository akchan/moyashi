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

ActiveRecord::Schema.define(version: 20150502120519) do

  create_table "labels", force: :cascade do |t|
    t.string   "name"
    t.text     "white_list"
    t.integer  "order",         default: 0
    t.boolean  "uniqueness",    default: false
    t.string   "column_name"
    t.string   "spectrum_type", default: "json"
    t.integer  "project_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "labels", ["project_id"], name: "index_labels_on_project_id"

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "information"
    t.integer  "columns",                   default: 0
    t.string   "spectrum_type",             default: "json"
    t.string   "default_spectrum_importer",   default: "default"
    t.string   "default_spectrum_renderer", default: "default"
    t.string   "default_spectrum_exporter", default: "default"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

end
