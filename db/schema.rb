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

ActiveRecord::Schema.define(:version => 20130627033923) do

  create_table "api_keys", :force => true do |t|
    t.string   "access_token"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "cinemas", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.text     "information"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.integer  "country_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "cities", ["country_id"], :name => "index_cities_on_country_id"

  create_table "comments", :force => true do |t|
    t.string   "author"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "show_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "comments", ["show_id"], :name => "index_comments_on_show_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

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
    t.string   "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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

  create_table "functions_showtimes", :id => false, :force => true do |t|
    t.integer "function_id"
    t.integer "showtime_id"
  end

  add_index "functions_showtimes", ["function_id"], :name => "index_function_showtimes_on_function_id"
  add_index "functions_showtimes", ["showtime_id"], :name => "index_function_showtimes_on_showtime_id"

  create_table "genres", :force => true do |t|
    t.string "name"
  end

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
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "image_tmp"
  end

  add_index "images", ["imageable_id", "imageable_type"], :name => "index_images_on_imageable_id_and_imageable_type"

  create_table "pages", :force => true do |t|
    t.string   "permalink"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "title"
  end

  add_index "pages", ["permalink"], :name => "index_pages_on_permalink"

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.date     "birthdate"
    t.date     "deathdate"
    t.string   "birthplace"
    t.integer  "height"
    t.text     "information"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "image_tmp"
  end

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
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.date     "debut"
    t.integer  "year"
    t.boolean  "active"
    t.string   "image_tmp"
    t.string   "facebook_id"
  end

  create_table "showtimes", :force => true do |t|
    t.time "time"
  end

  create_table "theaters", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.string   "address"
    t.text     "information"
    t.integer  "latitude"
    t.integer  "longitude"
    t.integer  "cinema_id"
    t.integer  "city_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "web_label"
    t.boolean  "active"
  end

  add_index "theaters", ["city_id", "cinema_id"], :name => "index_theaters_on_city_id_and_cinema_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "name"
    t.boolean  "admin"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "image"
  end

  create_table "videos", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "videoable_id"
    t.string   "videoable_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "image"
  end

  add_index "videos", ["videoable_id", "videoable_type"], :name => "index_videos_on_videoable_id_and_videoable_type"

end
