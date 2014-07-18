# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140718103457) do

  create_table "api_keys", :force => true do |t|
    t.string   "access_token"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "award_categories", :force => true do |t|
    t.string "name"
  end

  create_table "award_specific_categories", :force => true do |t|
    t.string   "name"
    t.string   "winner_type"
    t.integer  "winner_show"
    t.integer  "award_id"
    t.integer  "award_category_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "award_specific_categories", ["award_id", "award_category_id"], :name => "award_s_categories"

  create_table "award_types", :force => true do |t|
    t.string "name"
  end

  create_table "awards", :force => true do |t|
    t.string  "name"
    t.boolean "active"
    t.date    "date"
    t.string  "image"
    t.string  "image_tmp"
    t.integer "award_type_id"
  end

  add_index "awards", ["award_type_id"], :name => "index_awards_on_award_type_id"

  create_table "channels", :force => true do |t|
    t.string   "name"
    t.integer  "vtr"
    t.integer  "directv"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cinemas", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.text     "information"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "slug"
    t.string   "image_tmp"
  end

  add_index "cinemas", ["slug"], :name => "index_cinemas_on_slug", :unique => true

  create_table "cinemas_function_types", :id => false, :force => true do |t|
    t.integer "cinema_id"
    t.integer "function_type_id"
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.integer  "country_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "slug"
  end

  add_index "cities", ["country_id"], :name => "index_cities_on_country_id"
  add_index "cities", ["slug"], :name => "index_cities_on_slug", :unique => true

  create_table "comments", :force => true do |t|
    t.string   "author"
    t.text     "content"
    t.integer  "member_id"
    t.integer  "show_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "comments", ["member_id"], :name => "index_comments_on_member_id"
  add_index "comments", ["show_id"], :name => "index_comments_on_show_id"

  create_table "contact_tickets", :force => true do |t|
    t.string   "name"
    t.string   "from"
    t.string   "subject"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "slug"
  end

  add_index "countries", ["slug"], :name => "index_countries_on_slug", :unique => true

  create_table "function_types", :force => true do |t|
    t.string "name"
  end

  create_table "function_types_functions", :id => false, :force => true do |t|
    t.integer "function_id"
    t.integer "function_type_id"
  end

  add_index "function_types_functions", ["function_id", "function_type_id"], :name => "index_f_type_functions_on_f_id_and_f_type_id"

  create_table "functions", :force => true do |t|
    t.integer  "theater_id"
    t.integer  "show_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.date     "date"
  end

  add_index "functions", ["show_id"], :name => "index_functions_on_show_id"
  add_index "functions", ["theater_id"], :name => "index_functions_on_theater_id"

  create_table "genres", :force => true do |t|
    t.string "name"
    t.string "slug"
  end

  add_index "genres", ["slug"], :name => "index_genres_on_slug", :unique => true

  create_table "genres_shows", :id => false, :force => true do |t|
    t.integer "genre_id"
    t.integer "show_id"
  end

  add_index "genres_shows", ["genre_id", "show_id"], :name => "index_genres_shows_on_genre_id_and_show_id"

  create_table "images", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "image_tmp"
    t.integer  "width"
    t.integer  "height"
    t.integer  "show_portrait_id"
  end

  add_index "images", ["imageable_id", "imageable_type"], :name => "index_images_on_imageable_id_and_imageable_type"
  add_index "images", ["show_portrait_id"], :name => "index_images_on_show_portrait_id"

  create_table "members", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,     :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "authentication_token"
    t.boolean  "admin",                  :default => false
  end

  add_index "members", ["authentication_token"], :name => "index_members_on_authentication_token"
  add_index "members", ["email"], :name => "index_members_on_email", :unique => true
  add_index "members", ["reset_password_token"], :name => "index_members_on_reset_password_token", :unique => true

  create_table "nomination_person_roles", :force => true do |t|
    t.integer "nomination_id"
    t.integer "person_id"
  end

  add_index "nomination_person_roles", ["nomination_id", "person_id"], :name => "index_nomination_person_roles_on_nomination_id_and_person_id"

  create_table "nominations", :force => true do |t|
    t.boolean  "winner"
    t.integer  "award_specific_category_id"
    t.integer  "show_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "nominations", ["award_specific_category_id", "show_id"], :name => "index_nominations_on_award_specific_category_id_and_show_id"

  create_table "opinions", :force => true do |t|
    t.string "author"
    t.text   "comment"
    t.date   "date"
  end

  create_table "parse_detector_types", :force => true do |t|
    t.string  "name"
    t.integer "function_type_id"
    t.integer "cinema_id"
  end

  add_index "parse_detector_types", ["cinema_id"], :name => "index_parse_detector_types_on_cinema_id"
  add_index "parse_detector_types", ["function_type_id"], :name => "index_parse_detector_types_on_function_type_id"

  create_table "parsed_shows", :force => true do |t|
    t.string   "name"
    t.integer  "show_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "parsed_shows", ["show_id"], :name => "index_parsed_shows_on_show_id"

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "image_tmp"
    t.string   "slug"
    t.string   "imdb_code"
  end

  add_index "people", ["slug"], :name => "index_people_on_slug", :unique => true

  create_table "programs", :force => true do |t|
    t.datetime "time"
    t.string   "name"
    t.integer  "channel_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "programs", ["channel_id"], :name => "index_programs_on_channel_id"

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "show_person_roles", :force => true do |t|
    t.integer  "person_id"
    t.integer  "show_id"
    t.boolean  "actor"
    t.boolean  "writer"
    t.boolean  "creator"
    t.boolean  "producer"
    t.boolean  "director"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "character"
  end

  add_index "show_person_roles", ["person_id", "show_id"], :name => "index_show_person_roles_on_person_id_and_show_id"

  create_table "shows", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.text     "information"
    t.integer  "duration"
    t.string   "name_original"
    t.string   "rating"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.date     "debut"
    t.integer  "year"
    t.boolean  "active"
    t.string   "image_tmp"
    t.string   "facebook_id"
    t.string   "metacritic_url"
    t.integer  "metacritic_score"
    t.string   "imdb_code"
    t.integer  "imdb_score"
    t.string   "rotten_tomatoes_url"
    t.integer  "rotten_tomatoes_score"
    t.string   "slug"
  end

  add_index "shows", ["slug"], :name => "index_shows_on_slug", :unique => true

  create_table "showtimes", :force => true do |t|
    t.datetime "time"
    t.integer  "function_id"
  end

  add_index "showtimes", ["function_id"], :name => "index_showtimes_on_function_id"

  create_table "theaters", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.string   "address"
    t.text     "information"
    t.integer  "cinema_id"
    t.integer  "city_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.string   "web_url"
    t.boolean  "active"
    t.string   "slug"
    t.decimal  "latitude",    :precision => 15, :scale => 10
    t.decimal  "longitude",   :precision => 15, :scale => 10
  end

  add_index "theaters", ["city_id", "cinema_id"], :name => "index_theaters_on_city_id_and_cinema_id"
  add_index "theaters", ["slug"], :name => "index_theaters_on_slug", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "name"
    t.boolean  "admin"
    t.string   "slug"
  end

  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true

  create_table "videos", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "videoable_id"
    t.string   "videoable_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "image"
    t.string   "image_tmp"
    t.boolean  "outstanding"
  end

  add_index "videos", ["videoable_id", "videoable_type"], :name => "index_videos_on_videoable_id_and_videoable_type"

end
