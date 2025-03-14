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

ActiveRecord::Schema[7.1].define(version: 2025_03_01_015033) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "adventure_equipments", force: :cascade do |t|
    t.bigint "adventure_id", null: false
    t.bigint "equipment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adventure_id"], name: "index_adventure_equipments_on_adventure_id"
    t.index ["equipment_id"], name: "index_adventure_equipments_on_equipment_id"
  end

  create_table "adventure_skills", force: :cascade do |t|
    t.bigint "adventure_id", null: false
    t.bigint "skill_id", null: false
    t.boolean "is_required", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adventure_id", "skill_id"], name: "index_adventure_skills_on_adventure_id_and_skill_id", unique: true
    t.index ["adventure_id"], name: "index_adventure_skills_on_adventure_id"
    t.index ["skill_id"], name: "index_adventure_skills_on_skill_id"
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

  create_table "answers", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.text "content", null: false
    t.boolean "is_correct", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "equipment", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "spring_recommended", default: false
    t.boolean "summer_recommended", default: false
    t.boolean "autumn_recommended", default: false
    t.boolean "winter_recommended", default: false
  end

  create_table "equipment_skills", force: :cascade do |t|
    t.bigint "equipment_id", null: false
    t.bigint "skill_id", null: false
    t.text "usage_tips"
    t.boolean "is_required", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id", "skill_id"], name: "index_equipment_skills_on_equipment_id_and_skill_id", unique: true
    t.index ["equipment_id"], name: "index_equipment_skills_on_equipment_id"
    t.index ["skill_id"], name: "index_equipment_skills_on_skill_id"
  end

  create_table "location_equipments", force: :cascade do |t|
    t.bigint "equipment_id", null: false
    t.bigint "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id"], name: "index_location_equipments_on_equipment_id"
    t.index ["location_id"], name: "index_location_equipments_on_location_id"
  end

  create_table "location_skills", force: :cascade do |t|
    t.bigint "location_id", null: false
    t.bigint "skill_id", null: false
    t.boolean "is_required", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id", "skill_id"], name: "index_location_skills_on_location_id_and_skill_id", unique: true
    t.index ["location_id"], name: "index_location_skills_on_location_id"
    t.index ["skill_id"], name: "index_location_skills_on_skill_id"
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
    t.float "latitude"
    t.float "longitude"
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

  create_table "questions", force: :cascade do |t|
    t.bigint "quiz_id", null: false
    t.text "content", null: false
    t.string "difficulty", default: "medium"
    t.string "explanation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
  end

  create_table "quiz_answers", force: :cascade do |t|
    t.bigint "quiz_attempt_id", null: false
    t.bigint "question_id", null: false
    t.bigint "answer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_quiz_answers_on_answer_id"
    t.index ["question_id"], name: "index_quiz_answers_on_question_id"
    t.index ["quiz_attempt_id"], name: "index_quiz_answers_on_quiz_attempt_id"
  end

  create_table "quiz_attempts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "quiz_id", null: false
    t.integer "score"
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_quiz_attempts_on_quiz_id"
    t.index ["user_id"], name: "index_quiz_attempts_on_user_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.bigint "skill_id"
    t.bigint "adventure_id"
    t.bigint "equipment_id"
    t.string "category"
    t.string "difficulty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adventure_id"], name: "index_quizzes_on_adventure_id"
    t.index ["equipment_id"], name: "index_quizzes_on_equipment_id"
    t.index ["skill_id"], name: "index_quizzes_on_skill_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "difficulty", default: "beginner"
    t.string "category"
    t.text "instructions"
    t.text "resources"
    t.string "video_url"
    t.boolean "safety_critical", default: false
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

  create_table "travel_plan_skills", force: :cascade do |t|
    t.bigint "travel_plan_id", null: false
    t.bigint "skill_id", null: false
    t.boolean "is_mastered", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_id"], name: "index_travel_plan_skills_on_skill_id"
    t.index ["travel_plan_id", "skill_id"], name: "index_travel_plan_skills_on_travel_plan_id_and_skill_id", unique: true
    t.index ["travel_plan_id"], name: "index_travel_plan_skills_on_travel_plan_id"
  end

  create_table "travel_plans", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.string "status"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_date"
    t.datetime "end_date"
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
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "adventure_equipments", "adventures"
  add_foreign_key "adventure_equipments", "equipment"
  add_foreign_key "adventure_skills", "adventures"
  add_foreign_key "adventure_skills", "skills"
  add_foreign_key "answers", "questions"
  add_foreign_key "equipment_skills", "equipment"
  add_foreign_key "equipment_skills", "skills"
  add_foreign_key "location_equipments", "equipment"
  add_foreign_key "location_equipments", "locations"
  add_foreign_key "location_skills", "locations"
  add_foreign_key "location_skills", "skills"
  add_foreign_key "locations_adventures", "adventures"
  add_foreign_key "locations_adventures", "locations"
  add_foreign_key "questions", "quizzes"
  add_foreign_key "quiz_answers", "answers"
  add_foreign_key "quiz_answers", "questions"
  add_foreign_key "quiz_answers", "quiz_attempts"
  add_foreign_key "quiz_attempts", "quizzes"
  add_foreign_key "quiz_attempts", "users"
  add_foreign_key "quizzes", "adventures"
  add_foreign_key "quizzes", "equipment"
  add_foreign_key "quizzes", "skills"
  add_foreign_key "travel_plan_equipments", "equipment"
  add_foreign_key "travel_plan_equipments", "travel_plans"
  add_foreign_key "travel_plan_skills", "skills"
  add_foreign_key "travel_plan_skills", "travel_plans"
  add_foreign_key "travel_plans", "users"
  add_foreign_key "travel_plans_adventures", "adventures"
  add_foreign_key "travel_plans_adventures", "travel_plans"
  add_foreign_key "travel_plans_locations", "locations"
  add_foreign_key "travel_plans_locations", "travel_plans"
  add_foreign_key "user_equipments", "equipment"
  add_foreign_key "user_equipments", "users"
end
