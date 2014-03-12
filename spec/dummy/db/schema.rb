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

ActiveRecord::Schema.define(version: 20140312204736) do

  create_table "helena_labels", force: true do |t|
    t.integer  "question_id"
    t.string   "text",                        null: false
    t.string   "value",                       null: false
    t.integer  "position",    default: 1
    t.boolean  "preselected", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version",     default: 0
  end

  create_table "helena_participants", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "helena_question_groups", force: true do |t|
    t.integer  "survey_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",   default: 1
    t.integer  "version",    default: 0
  end

  create_table "helena_questions", force: true do |t|
    t.integer  "question_group_id"
    t.integer  "survey_id"
    t.string   "type"
    t.string   "code",                          null: false
    t.integer  "position",          default: 1
    t.string   "question_text"
    t.text     "default_value"
    t.text     "validation_rules"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version",           default: 0
  end

  create_table "helena_sub_questions", force: true do |t|
    t.integer  "question_id"
    t.string   "code",                    null: false
    t.integer  "position",    default: 1
    t.string   "text"
    t.text     "value"
    t.boolean  "preselected"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version",     default: 0
  end

  create_table "helena_surveys", force: true do |t|
    t.integer  "participant_id"
    t.string   "name",                       null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",       default: 1
  end

  create_table "helena_versions", force: true do |t|
    t.integer  "survey_id"
    t.integer  "version",    default: 0, null: false
    t.string   "title"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
