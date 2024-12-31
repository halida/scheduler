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

ActiveRecord::Schema[8.0].define(version: 2024_12_31_025117) do
  create_table "applications", charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "token"
    t.boolean "enabled", default: true
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "execution_methods", charset: "latin1", force: :cascade do |t|
    t.string "title"
    t.string "execution_type"
    t.text "parameters"
    t.boolean "enabled", default: true
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "executions", charset: "latin1", force: :cascade do |t|
    t.integer "plan_id"
    t.integer "routine_id"
    t.string "token"
    t.string "status", default: "init"
    t.text "log", size: :medium
    t.text "result", size: :medium
    t.datetime "scheduled_at", precision: nil
    t.datetime "timeout_at", precision: nil
    t.datetime "started_at", precision: nil
    t.datetime "finished_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["plan_id"], name: "index_executions_on_plan_id"
    t.index ["scheduled_at"], name: "index_executions_on_scheduled_at"
    t.index ["token"], name: "index_executions_on_token"
  end

  create_table "plans", charset: "latin1", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "execution_method_id"
    t.string "parameters"
    t.integer "waiting", default: 180
    t.string "token"
    t.boolean "enabled", default: true
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "review_only", default: false
    t.integer "application_id"
    t.index ["application_id"], name: "index_plans_on_application_id"
    t.index ["execution_method_id"], name: "index_plans_on_execution_method_id"
    t.index ["token"], name: "index_plans_on_token"
  end

  create_table "routines", charset: "latin1", force: :cascade do |t|
    t.integer "plan_id"
    t.string "config"
    t.string "timezone", default: "UTC"
    t.boolean "enabled", default: true
    t.integer "modify", default: 0
    t.index ["plan_id"], name: "index_routines_on_plan_id"
  end

  create_table "users", charset: "latin1", force: :cascade do |t|
    t.string "username"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.string "timezone", default: "UTC"
    t.boolean "email_notify", default: false
    t.boolean "email_daily_report", default: false
    t.integer "email_daily_report_time", default: 8
    t.datetime "email_daily_report_checked_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end
end
