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

ActiveRecord::Schema.define(version: 20170210023050) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "award_categories", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "award_specific_categories", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "winner_type",       limit: 255
    t.integer  "winner_show"
    t.integer  "award_id"
    t.integer  "award_category_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["award_id", "award_category_id"], name: "award_s_categories", using: :btree
  end

  create_table "award_types", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "awards", force: :cascade do |t|
    t.string  "name",          limit: 255
    t.boolean "active"
    t.date    "date"
    t.string  "image",         limit: 255
    t.string  "image_tmp",     limit: 255
    t.integer "award_type_id"
    t.index ["award_type_id"], name: "index_awards_on_award_type_id", using: :btree
  end

  create_table "channels", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "vtr"
    t.integer  "directv"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "cinemas", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "image",       limit: 255
    t.text     "information"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "slug",        limit: 255
    t.string   "image_tmp",   limit: 255
    t.index ["slug"], name: "index_cinemas_on_slug", unique: true, using: :btree
  end

  create_table "cinemas_function_types", id: false, force: :cascade do |t|
    t.integer "cinema_id"
    t.integer "function_type_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "image",      limit: 255
    t.integer  "country_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "slug",       limit: 255
    t.index ["country_id"], name: "index_cities_on_country_id", using: :btree
    t.index ["slug"], name: "index_cities_on_slug", unique: true, using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.string   "author",     limit: 255
    t.text     "content"
    t.integer  "member_id"
    t.integer  "show_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["member_id"], name: "index_comments_on_member_id", using: :btree
    t.index ["show_id"], name: "index_comments_on_show_id", using: :btree
  end

  create_table "contact_tickets", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "from",       limit: 255
    t.string   "subject",    limit: 255
    t.text     "content"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "slug",       limit: 255
    t.string   "image"
    t.index ["slug"], name: "index_countries_on_slug", unique: true, using: :btree
  end

  create_table "countries_shows", id: false, force: :cascade do |t|
    t.integer "country_id", null: false
    t.integer "show_id",    null: false
    t.index ["show_id"], name: "index_countries_shows_on_show_id", using: :btree
  end

  create_table "function_types", force: :cascade do |t|
    t.string "name",  limit: 255
    t.string "color", limit: 255
  end

  create_table "function_types_functions", id: false, force: :cascade do |t|
    t.integer "function_id"
    t.integer "function_type_id"
    t.index ["function_id", "function_type_id"], name: "index_f_type_functions_on_f_id_and_f_type_id", using: :btree
  end

  create_table "functions", force: :cascade do |t|
    t.integer  "theater_id"
    t.integer  "show_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.date     "date"
    t.integer  "parsed_show_id"
    t.string   "showtimes"
    t.index ["parsed_show_id"], name: "index_functions_on_parsed_show_id", using: :btree
    t.index ["show_id"], name: "index_functions_on_show_id", using: :btree
    t.index ["theater_id"], name: "index_functions_on_theater_id", using: :btree
  end

  create_table "genres", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "slug", limit: 255
    t.index ["slug"], name: "index_genres_on_slug", unique: true, using: :btree
  end

  create_table "genres_shows", id: false, force: :cascade do |t|
    t.integer "genre_id"
    t.integer "show_id"
    t.index ["genre_id", "show_id"], name: "index_genres_shows_on_genre_id_and_show_id", using: :btree
  end

  create_table "images", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "image",            limit: 255
    t.integer  "imageable_id"
    t.string   "imageable_type",   limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "image_tmp",        limit: 255
    t.integer  "width"
    t.integer  "height"
    t.integer  "show_portrait_id"
    t.boolean  "poster"
    t.boolean  "backdrop"
    t.index ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type", using: :btree
    t.index ["show_portrait_id"], name: "index_images_on_show_portrait_id", using: :btree
  end

  create_table "members", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "authentication_token",   limit: 255
    t.boolean  "admin",                              default: false
    t.index ["authentication_token"], name: "index_members_on_authentication_token", using: :btree
    t.index ["email"], name: "index_members_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true, using: :btree
  end

  create_table "nomination_person_roles", force: :cascade do |t|
    t.integer "nomination_id"
    t.integer "person_id"
    t.index ["nomination_id", "person_id"], name: "index_nomination_person_roles_on_nomination_id_and_person_id", using: :btree
  end

  create_table "nominations", force: :cascade do |t|
    t.boolean  "winner"
    t.integer  "award_specific_category_id"
    t.integer  "show_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["award_specific_category_id", "show_id"], name: "index_nominations_on_award_specific_category_id_and_show_id", using: :btree
  end

  create_table "opinions", force: :cascade do |t|
    t.string "author",  limit: 255
    t.text   "comment"
    t.date   "date"
  end

  create_table "parse_detector_types", force: :cascade do |t|
    t.string  "name",             limit: 255
    t.integer "function_type_id"
    t.integer "cinema_id"
    t.index ["cinema_id"], name: "index_parse_detector_types_on_cinema_id", using: :btree
    t.index ["function_type_id"], name: "index_parse_detector_types_on_function_type_id", using: :btree
  end

  create_table "parsed_shows", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "show_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["show_id"], name: "index_parsed_shows_on_show_id", using: :btree
  end

  create_table "people", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "image",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "image_tmp",  limit: 255
    t.string   "slug",       limit: 255
    t.string   "imdb_code",  limit: 255
    t.index ["slug"], name: "index_people_on_slug", unique: true, using: :btree
  end

  create_table "programs", force: :cascade do |t|
    t.datetime "time"
    t.string   "name",       limit: 255
    t.integer  "channel_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["channel_id"], name: "index_programs_on_channel_id", using: :btree
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255, null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",        limit: 255, null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree
  end

  create_table "show_debuts", force: :cascade do |t|
    t.integer  "show_id"
    t.date     "debut"
    t.datetime "created_at"
    t.index ["show_id"], name: "index_show_debuts_on_show_id", using: :btree
  end

  create_table "show_person_roles", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "show_id"
    t.boolean  "actor",                  default: true
    t.boolean  "writer"
    t.boolean  "creator"
    t.boolean  "producer"
    t.boolean  "director"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "character",  limit: 255
    t.integer  "position"
    t.index ["person_id", "show_id"], name: "index_show_person_roles_on_person_id_and_show_id", using: :btree
  end

  create_table "shows", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.text     "information"
    t.integer  "duration"
    t.string   "name_original",         limit: 255
    t.string   "rating",                limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.date     "debut"
    t.integer  "year"
    t.boolean  "active"
    t.string   "facebook_id",           limit: 255
    t.string   "metacritic_url",        limit: 255
    t.integer  "metacritic_score"
    t.string   "imdb_code",             limit: 255
    t.integer  "imdb_score"
    t.string   "rotten_tomatoes_url",   limit: 255
    t.integer  "rotten_tomatoes_score"
    t.string   "slug",                  limit: 255
    t.index ["slug"], name: "index_shows_on_slug", unique: true, using: :btree
  end

  create_table "showtimes", force: :cascade do |t|
    t.datetime "time"
    t.integer  "function_id"
    t.index ["function_id"], name: "index_showtimes_on_function_id", using: :btree
  end

  create_table "theaters", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "image",             limit: 255
    t.string   "address",           limit: 255
    t.text     "information"
    t.integer  "cinema_id"
    t.integer  "city_id"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "web_url",           limit: 255
    t.boolean  "active"
    t.string   "slug",              limit: 255
    t.decimal  "latitude",                      precision: 15, scale: 10
    t.decimal  "longitude",                     precision: 15, scale: 10
    t.string   "parse_helper",      limit: 255
    t.integer  "parent_theater_id"
    t.index ["city_id", "cinema_id"], name: "index_theaters_on_city_id_and_cinema_id", using: :btree
    t.index ["slug"], name: "index_theaters_on_slug", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",           limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "name",            limit: 255
    t.boolean  "admin"
    t.string   "slug",            limit: 255
    t.index ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  end

  create_table "videos", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "code",           limit: 255
    t.integer  "videoable_id"
    t.string   "videoable_type", limit: 255
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "image",          limit: 255
    t.string   "image_tmp",      limit: 255
    t.boolean  "outstanding",                default: true
    t.integer  "video_type",                 default: 0
    t.index ["videoable_id", "videoable_type"], name: "index_videos_on_videoable_id_and_videoable_type", using: :btree
  end

end
