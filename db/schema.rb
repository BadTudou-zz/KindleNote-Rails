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

ActiveRecord::Schema.define(version: 20171118071617) do

  create_table "access_tokens", force: :cascade do |t|
    t.integer "user_id"
    t.text "name"
    t.text "access_token"
    t.text "scopes"
    t.datetime "expires"
    t.boolean "revoked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "openid"
    t.index ["user_id"], name: "index_access_tokens_on_user_id"
  end

  create_table "fragments", force: :cascade do |t|
    t.integer "note_id"
    t.integer "user_id"
    t.string "fragment_type"
    t.text "content"
    t.string "datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "note_id", "content"], name: "index_fragments_on_user_id_and_note_id_and_content", unique: true
  end

  create_table "notes", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.string "cover_url"
    t.decimal "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "summary"
  end

  create_table "notes_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["note_id"], name: "index_notes_users_on_note_id"
    t.index ["user_id"], name: "index_notes_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "rember_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "openid"
  end

end
