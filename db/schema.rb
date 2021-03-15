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

ActiveRecord::Schema.define(version: 2021_03_09_150047) do

  create_table "activities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "schedule", size: :medium, null: false
    t.bigint "plan_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_id"], name: "index_activities_on_plan_id"
  end

  create_table "group_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_group_types_on_name", unique: true
  end

  create_table "memberships", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "role", default: 0, null: false
    t.bigint "user_group_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_group_id", "user_id"], name: "index_memberships_on_user_group_id_and_user_id", unique: true
    t.index ["user_group_id"], name: "index_memberships_on_user_group_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "notes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "content", null: false
    t.integer "state", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.timestamp "start_time", null: false
    t.timestamp "end_time", null: false
    t.bigint "author_id"
    t.string "subject_type"
    t.bigint "subject_id"
    t.index ["author_id"], name: "index_notes_on_author_id"
    t.index ["subject_type", "subject_id"], name: "index_notes_on_subject_type_and_subject_id"
  end

  create_table "plans", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_plans_on_user_id"
  end

  create_table "signoffs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "plan_id", null: false
    t.datetime "signed_at"
    t.datetime "revoked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_id"], name: "index_signoffs_on_plan_id"
    t.index ["user_id"], name: "index_signoffs_on_user_id"
  end

  create_table "tag_associations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "taggable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "tag_type_id", null: false
    t.string "taggable_type", null: false
    t.index ["tag_id"], name: "index_tag_associations_on_tag_id"
    t.index ["tag_type_id"], name: "index_tag_associations_on_tag_type_id"
    t.index ["taggable_id"], name: "index_tag_associations_on_taggable_id"
    t.index ["taggable_type", "taggable_id", "tag_type_id", "tag_id"], name: "index_tag_associations_uniqueness", unique: true
  end

  create_table "tag_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "parent_id"
    t.datetime "active_for_activities_at"
    t.datetime "active_for_time_ranges_at"
    t.index ["name"], name: "index_tag_types_on_name", unique: true
    t.index ["parent_id"], name: "index_tag_types_on_parent_id"
  end

  create_table "tags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "tag_type_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "parent_id"
    t.boolean "default_for_filter", default: false, null: false
    t.index ["parent_id", "name"], name: "index_tags_on_parent_id_and_name", unique: true
    t.index ["parent_id"], name: "index_tags_on_parent_id"
    t.index ["tag_type_id"], name: "index_tags_on_tag_type_id"
  end

  create_table "time_range_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_time_range_types_on_name", unique: true
  end

  create_table "time_ranges", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.timestamp "start_time", null: false
    t.timestamp "end_time", null: false
    t.decimal "value", precision: 65, scale: 30, null: false
    t.bigint "time_range_type_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["time_range_type_id", "user_id", "start_time", "end_time", "value"], name: "index_time_range_team_stats"
    t.index ["time_range_type_id"], name: "index_time_ranges_on_time_range_type_id"
    t.index ["user_id"], name: "index_time_ranges_on_user_id"
  end

  create_table "user_groups", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "group_type_id", null: false
    t.index ["group_type_id"], name: "index_user_groups_on_group_type_id"
    t.index ["name", "group_type_id"], name: "index_user_groups_on_name_and_group_type_id", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin", default: false, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "epr_uuid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["epr_uuid"], name: "index_users_on_epr_uuid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "memberships", "user_groups"
  add_foreign_key "memberships", "users"
  add_foreign_key "signoffs", "plans"
  add_foreign_key "signoffs", "users"
  add_foreign_key "user_groups", "group_types"
end
