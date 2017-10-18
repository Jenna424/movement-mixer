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

ActiveRecord::Schema.define(version: 20171018134226) do

  create_table "movement_routines", force: :cascade do |t|
    t.integer "routine_id"
    t.integer "movement_id"
  end

  create_table "movements", force: :cascade do |t|
    t.text "instructions"
    t.string "target_area"
    t.integer "reps"
    t.string "modification"
    t.string "challenge"
    t.string "name"
    t.integer "user_id"
    t.integer "sets"
  end

  create_table "routines", force: :cascade do |t|
    t.string "name"
    t.string "training_type"
    t.string "duration"
    t.string "difficulty_level"
    t.string "equipment"
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
  end

end
