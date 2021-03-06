# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_05_02_051436) do

  create_table "agreements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "host_id", null: false
    t.datetime "start_time", null: false
    t.datetime "finish_time", null: false
    t.integer "state", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "room_id", null: false
    t.index ["host_id"], name: "index_agreements_on_host_id"
    t.index ["room_id"], name: "index_agreements_on_room_id"
    t.index ["user_id"], name: "index_agreements_on_user_id"
  end

  create_table "cancell_comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "agreement_id", null: false
    t.text "comment", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["agreement_id"], name: "index_cancell_comments_on_agreement_id"
  end

  create_table "free_times", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "start_time", null: false
    t.datetime "finish_time", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_free_times_on_user_id"
  end

  create_table "host_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "message", null: false
    t.bigint "room_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["room_id"], name: "index_host_messages_on_room_id"
  end

  create_table "host_notices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "action", null: false
    t.bigint "host_id", null: false
    t.string "source_type", null: false
    t.bigint "source_id", null: false
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["host_id"], name: "index_host_notices_on_host_id"
    t.index ["source_type", "source_id"], name: "index_host_notices_on_source_type_and_source_id"
  end

  create_table "host_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.datetime "start_time", null: false
    t.datetime "finish_time", null: false
    t.bigint "host_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "free_time_id", null: false
    t.index ["free_time_id"], name: "index_host_requests_on_free_time_id"
    t.index ["host_id"], name: "index_host_requests_on_host_id"
  end

  create_table "host_skills", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "host_id", null: false
    t.bigint "skill_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["host_id", "skill_id"], name: "index_host_skills_on_host_id_and_skill_id", unique: true
    t.index ["host_id"], name: "index_host_skills_on_host_id"
    t.index ["skill_id"], name: "index_host_skills_on_skill_id"
  end

  create_table "hosts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "name", null: false
    t.string "email", null: false
    t.string "address"
    t.string "image"
    t.boolean "wanted", default: false, null: false
    t.text "profile"
    t.text "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "myid", null: false
    t.string "phone", null: false
    t.float "lat", limit: 53
    t.float "lng", limit: 53
    t.datetime "deleted_at"
    t.index ["confirmation_token"], name: "index_hosts_on_confirmation_token", unique: true
    t.index ["email"], name: "index_hosts_on_email", unique: true
    t.index ["myid"], name: "index_hosts_on_myid", unique: true
    t.index ["reset_password_token"], name: "index_hosts_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_hosts_on_uid_and_provider", unique: true
  end

  create_table "rates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "star", null: false
    t.text "comment", null: false
    t.bigint "agreement_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["agreement_id"], name: "index_rates_on_agreement_id"
  end

  create_table "recruitment_times", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.datetime "start_time", null: false
    t.datetime "finish_time", null: false
    t.bigint "host_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["host_id"], name: "index_recruitment_times_on_host_id"
  end

  create_table "rooms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "host_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "start_time", null: false
    t.datetime "finish_time", null: false
    t.integer "state", default: 0, null: false
    t.integer "closed", default: 0, null: false
    t.index ["host_id"], name: "index_rooms_on_host_id"
    t.index ["user_id"], name: "index_rooms_on_user_id"
  end

  create_table "skills", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_skills_on_name", unique: true
  end

  create_table "user_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "message", null: false
    t.bigint "room_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["room_id"], name: "index_user_messages_on_room_id"
  end

  create_table "user_notices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "action", null: false
    t.bigint "user_id", null: false
    t.string "source_type", null: false
    t.bigint "source_id", null: false
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["source_type", "source_id"], name: "index_user_notices_on_source_type_and_source_id"
    t.index ["user_id"], name: "index_user_notices_on_user_id"
  end

  create_table "user_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.datetime "start_time", null: false
    t.datetime "finish_time", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "recruitment_time_id", null: false
    t.index ["recruitment_time_id"], name: "index_user_requests_on_recruitment_time_id"
    t.index ["user_id"], name: "index_user_requests_on_user_id"
  end

  create_table "user_skills", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "skill_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["skill_id"], name: "index_user_skills_on_skill_id"
    t.index ["user_id", "skill_id"], name: "index_user_skills_on_user_id_and_skill_id", unique: true
    t.index ["user_id"], name: "index_user_skills_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "name", null: false
    t.string "email", null: false
    t.string "address"
    t.string "image"
    t.boolean "wanted", default: false, null: false
    t.boolean "sex", default: false, null: false
    t.integer "age"
    t.integer "year"
    t.text "profile"
    t.text "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "myid", null: false
    t.float "lat", limit: 53
    t.float "lng", limit: 53
    t.datetime "deleted_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["myid"], name: "index_users_on_myid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "agreements", "hosts"
  add_foreign_key "agreements", "rooms"
  add_foreign_key "agreements", "users"
  add_foreign_key "cancell_comments", "agreements"
  add_foreign_key "free_times", "users"
  add_foreign_key "host_messages", "rooms"
  add_foreign_key "host_notices", "hosts"
  add_foreign_key "host_requests", "free_times"
  add_foreign_key "host_requests", "hosts"
  add_foreign_key "host_skills", "hosts"
  add_foreign_key "host_skills", "skills"
  add_foreign_key "rates", "agreements"
  add_foreign_key "recruitment_times", "hosts"
  add_foreign_key "rooms", "hosts"
  add_foreign_key "rooms", "users"
  add_foreign_key "user_messages", "rooms"
  add_foreign_key "user_notices", "users"
  add_foreign_key "user_requests", "recruitment_times"
  add_foreign_key "user_requests", "users"
  add_foreign_key "user_skills", "skills"
  add_foreign_key "user_skills", "users"
end
