# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_02_08_091054) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adventures", force: :cascade do |t|
    t.string "name"
    t.string "details"
    t.string "tips"
    t.string "warnings"
    t.string "skills"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_id"
    t.index ["location_id"], name: "index_adventures_on_location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "details"
    t.string "city"
    t.string "prefecture"
    t.string "tips"
    t.string "warnings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "activity_name"
  end

  create_table "locations_adventures", force: :cascade do |t|
    t.bigint "adventure_id", null: false
    t.bigint "location_id", null: false
    t.text "additionaldetails"
    t.text "warnings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adventure_id"], name: "index_locations_adventures_on_adventure_id"
    t.index ["location_id"], name: "index_locations_adventures_on_location_id"
  end

  create_table "travel_plans", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.string "status"
    t.bigint "adventure_id"
    t.bigint "location_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adventure_id"], name: "index_travel_plans_on_adventure_id"
    t.index ["location_id"], name: "index_travel_plans_on_location_id"
    t.index ["user_id"], name: "index_travel_plans_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "locations_adventures", "adventures"
  add_foreign_key "locations_adventures", "locations"
  add_foreign_key "travel_plans", "adventures"
  add_foreign_key "travel_plans", "locations"
  add_foreign_key "travel_plans", "users"
end
