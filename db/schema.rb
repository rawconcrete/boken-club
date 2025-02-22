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

ActiveRecord::Schema[7.1].define(version: 2025_02_21_234240) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adventure_equipments", force: :cascade do |t|
    t.bigint "adventure_id", null: false
    t.bigint "equipment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adventure_id"], name: "index_adventure_equipments_on_adventure_id"
    t.index ["equipment_id"], name: "index_adventure_equipments_on_equipment_id"
  end

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

  create_table "equipment", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "location_equipments", force: :cascade do |t|
    t.bigint "location_id", null: false
    t.bigint "equipment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id"], name: "index_location_equipments_on_equipment_id"
    t.index ["location_id"], name: "index_location_equipments_on_location_id"
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
    t.string "adventure_name"
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

  create_table "tips", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "travel_plan_equipments", force: :cascade do |t|
    t.bigint "travel_plan_id", null: false
    t.bigint "equipment_id", null: false
    t.boolean "checked", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id"], name: "index_travel_plan_equipments_on_equipment_id"
    t.index ["travel_plan_id"], name: "index_travel_plan_equipments_on_travel_plan_id"
  end

  create_table "travel_plans", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.string "status"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_travel_plans_on_user_id"
  end

  create_table "travel_plans_adventures", force: :cascade do |t|
    t.bigint "travel_plan_id", null: false
    t.bigint "adventure_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adventure_id"], name: "index_travel_plans_adventures_on_adventure_id"
    t.index ["travel_plan_id"], name: "index_travel_plans_adventures_on_travel_plan_id"
  end

  create_table "travel_plans_locations", force: :cascade do |t|
    t.bigint "travel_plan_id", null: false
    t.bigint "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_travel_plans_locations_on_location_id"
    t.index ["travel_plan_id"], name: "index_travel_plans_locations_on_travel_plan_id"
  end

  create_table "user_equipments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "equipment_id", null: false
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id"], name: "index_user_equipments_on_equipment_id"
    t.index ["user_id"], name: "index_user_equipments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.integer "role", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "adventure_equipments", "adventures"
  add_foreign_key "adventure_equipments", "equipment"
  add_foreign_key "location_equipments", "equipment"
  add_foreign_key "location_equipments", "locations"
  add_foreign_key "locations_adventures", "adventures"
  add_foreign_key "locations_adventures", "locations"
  add_foreign_key "travel_plan_equipments", "equipment"
  add_foreign_key "travel_plan_equipments", "travel_plans"
  add_foreign_key "travel_plans", "users"
  add_foreign_key "travel_plans_adventures", "adventures"
  add_foreign_key "travel_plans_adventures", "travel_plans"
  add_foreign_key "travel_plans_locations", "locations"
  add_foreign_key "travel_plans_locations", "travel_plans"
  add_foreign_key "user_equipments", "equipment"
  add_foreign_key "user_equipments", "users"
end
