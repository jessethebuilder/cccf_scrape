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

ActiveRecord::Schema.define(version: 2021_08_18_025029) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bonds", force: :cascade do |t|
    t.string "number"
    t.string "bond_type"
    t.float "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.datetime "date"
    t.datetime "release_date"
    t.datetime "scheduled_release_date"
    t.string "facility"
    t.string "origin"
    t.float "total_bond_amount"
    t.float "total_bail_amount"
    t.string "number"
    t.bigint "inmate_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["inmate_id"], name: "index_bookings_on_inmate_id"
  end

  create_table "charges", force: :cascade do |t|
    t.string "description"
    t.datetime "offense_date"
    t.string "docket_number"
    t.string "disposition"
    t.date "disposition_date"
    t.string "arrested_by"
    t.string "commit"
    t.string "court"
    t.bigint "booking_id", null: false
    t.bigint "bond_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bond_id"], name: "index_charges_on_bond_id"
    t.index ["booking_id"], name: "index_charges_on_booking_id"
  end

  create_table "inmates", force: :cascade do |t|
    t.string "name"
    t.string "number"
    t.string "age"
    t.string "gender"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.boolean "send_new_bookings", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "bookings", "inmates"
  add_foreign_key "charges", "bonds"
  add_foreign_key "charges", "bookings"
end
