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

ActiveRecord::Schema.define(version: 2023_09_06_210518) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "timescaledb"

  create_table "channels", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "sensor_type", null: false
    t.string "location"
    t.string "device_id"
    t.string "product_id"
    t.datetime "last_entry_timestamp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["device_id"], name: "index_channels_on_device_id", unique: true
    t.index ["sensor_type"], name: "index_channels_on_sensor_type"
  end

  create_table "measurements", id: false, force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.text "metric", null: false
    t.float "value"
    t.datetime "created_at", null: false
    t.index ["channel_id", "metric", "created_at"], name: "index_measurements_on_channel_id_and_metric_and_created_at", unique: true
    t.index ["channel_id"], name: "index_measurements_on_channel_id"
    t.index ["created_at"], name: "measurements_created_at_idx", order: :desc
  end

  create_table "ubibot_auths", id: false, force: :cascade do |t|
    t.datetime "created_at", default: "2023-09-15 17:44:03"
    t.datetime "expired_at"
    t.datetime "server_time"
    t.string "token_ciphertext"
    t.index ["created_at", "expired_at"], name: "index_ubibot_auths_on_created_at_and_expired_at", unique: true
    t.index ["created_at"], name: "index_ubibot_auths_on_created_at"
    t.index ["expired_at"], name: "index_ubibot_auths_on_expired_at"
  end

  add_foreign_key "measurements", "channels"
end
