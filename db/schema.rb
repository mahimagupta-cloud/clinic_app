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

ActiveRecord::Schema[8.1].define(version: 2026_09_03_060851) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "doctor_id", null: false
    t.bigint "patient_id", null: false
    t.datetime "scheduled_at", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id", "scheduled_at"], name: "index_appointments_on_doctor_id_and_scheduled_at", unique: true
    t.index ["doctor_id"], name: "index_appointments_on_doctor_id"
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
  end

  create_table "clinics", force: :cascade do |t|
    t.string "address"
    t.string "city"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "consultations", force: :cascade do |t|
    t.bigint "appointment_id", null: false
    t.datetime "created_at", null: false
    t.text "diagnosis"
    t.bigint "doctor_id", null: false
    t.decimal "fee", precision: 10, scale: 2, null: false
    t.text "notes"
    t.bigint "patient_id", null: false
    t.text "symptoms"
    t.datetime "updated_at", null: false
    t.datetime "visited_at", null: false
    t.index ["appointment_id"], name: "index_consultations_on_appointment_id", unique: true
    t.index ["doctor_id"], name: "index_consultations_on_doctor_id"
    t.index ["patient_id"], name: "index_consultations_on_patient_id"
  end

  create_table "doctor_availabilities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "day_of_week"
    t.bigint "doctor_id", null: false
    t.time "end_time"
    t.time "start_time"
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_doctor_availabilities_on_doctor_id"
  end

  create_table "doctors", force: :cascade do |t|
    t.text "bio"
    t.bigint "clinic_id"
    t.decimal "consultation_fee", precision: 10
    t.datetime "created_at", null: false
    t.integer "experience"
    t.string "medical_license_number"
    t.string "name"
    t.string "specialization"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["clinic_id"], name: "index_doctors_on_clinic_id"
    t.index ["medical_license_number"], name: "index_doctors_on_medical_license_number", unique: true
    t.index ["user_id"], name: "index_doctors_on_user_id"
  end

  create_table "patients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_patients_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.bigint "appointment_id", null: false
    t.datetime "created_at", null: false
    t.string "gateway_order_id"
    t.string "gateway_payment_id"
    t.string "payment_method"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_payments_on_appointment_id", unique: true
    t.index ["gateway_order_id"], name: "index_payments_on_gateway_order_id"
    t.index ["gateway_payment_id"], name: "index_payments_on_gateway_payment_id"
  end

  create_table "prescription_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "dosage"
    t.string "duration"
    t.string "frequency"
    t.text "instructions"
    t.string "medicine_name", null: false
    t.bigint "prescription_id", null: false
    t.datetime "updated_at", null: false
    t.index ["prescription_id"], name: "index_prescription_items_on_prescription_id"
  end

  create_table "prescriptions", force: :cascade do |t|
    t.bigint "consultation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consultation_id"], name: "index_prescriptions_on_consultation_id", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.bigint "doctor_id", null: false
    t.bigint "patient_id", null: false
    t.integer "rating"
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_reviews_on_doctor_id"
    t.index ["patient_id"], name: "index_reviews_on_patient_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "appointments", "doctors"
  add_foreign_key "appointments", "patients"
  add_foreign_key "consultations", "appointments"
  add_foreign_key "consultations", "doctors"
  add_foreign_key "consultations", "patients"
  add_foreign_key "doctor_availabilities", "doctors"
  add_foreign_key "doctors", "clinics"
  add_foreign_key "doctors", "users"
  add_foreign_key "patients", "users"
  add_foreign_key "payments", "appointments"
  add_foreign_key "prescription_items", "prescriptions"
  add_foreign_key "prescriptions", "consultations"
  add_foreign_key "reviews", "doctors"
  add_foreign_key "reviews", "patients"
  add_foreign_key "sessions", "users"
end
