# == Route Map
#
#                                        Prefix Verb   URI Pattern                                                                     Controller#Action
#                            new_member_session GET    /members/sign_in(.:format)                                                      devise/sessions#new
#                                member_session POST   /members/sign_in(.:format)                                                      devise/sessions#create
#                        destroy_member_session DELETE /members/sign_out(.:format)                                                     devise/sessions#destroy
#                               member_password POST   /members/password(.:format)                                                     devise/passwords#create
#                           new_member_password GET    /members/password/new(.:format)                                                 devise/passwords#new
#                          edit_member_password GET    /members/password/edit(.:format)                                                devise/passwords#edit
#                                               PATCH  /members/password(.:format)                                                     devise/passwords#update
#                                               PUT    /members/password(.:format)                                                     devise/passwords#update
#                    cancel_member_registration GET    /members/cancel(.:format)                                                       devise/registrations#cancel
#                           member_registration POST   /members(.:format)                                                              devise/registrations#create
#                       new_member_registration GET    /members/sign_up(.:format)                                                      devise/registrations#new
#                      edit_member_registration GET    /members/edit(.:format)                                                         devise/registrations#edit
#                                               PATCH  /members(.:format)                                                              devise/registrations#update
#                                               PUT    /members(.:format)                                                              devise/registrations#update
#                                               DELETE /members(.:format)                                                              devise/registrations#destroy
#                                          root GET    /                                                                               home#index
#                                  api_register POST   /api/registrations(.:format)                                                    api/v3/registrations#create {:format=>"json"}
#                                     api_login POST   /api/sessions(.:format)                                                         api/v3/sessions#create {:format=>"json"}
#                                    api_logout DELETE /api/sessions(.:format)                                                         api/v3/sessions#destroy {:format=>"json"}
#                           billboard_api_shows GET    /api/shows/billboard(.:format)                                                  api/v3/shows#billboard {:format=>"json"}
#                          comingsoon_api_shows GET    /api/shows/comingsoon(.:format)                                                 api/v3/shows#comingsoon {:format=>"json"}
#                                               GET    /api/shows/:show_id/show_theaters(.:format)                                     api/v3/theaters#show_theaters {:format=>"json"}
#                                               GET    /api/shows/:show_id/favorite_theaters(.:format)                                 api/v3/theaters#favorite_theaters {:format=>"json"}
#                                               GET    /api/shows/:show_id/show_functions(.:format)                                    api/v3/functions#show_functions {:format=>"json"}
#                                      api_show GET    /api/shows/:id(.:format)                                                        api/v3/shows#show {:format=>"json"}
#                                    api_awards GET    /api/awards(.:format)                                                           api/v3/awards#index {:format=>"json"}
#                                    api_videos GET    /api/videos(.:format)                                                           api/v3/videos#index {:format=>"json"}
#                         api_theater_functions GET    /api/theaters/:theater_id/functions(.:format)                                   api/v3/functions#index {:format=>"json"}
#              theater_coordinates_api_theaters GET    /api/theaters/theater_coordinates(.:format)                                     api/v3/theaters#theater_coordinates {:format=>"json"}
#                                   api_theater GET    /api/theaters/:id(.:format)                                                     api/v3/theaters#show {:format=>"json"}
#                           api_cinema_theaters GET    /api/cinemas/:cinema_id/theaters(.:format)                                      api/v3/theaters#index {:format=>"json"}
#                                    api_cinema GET    /api/cinemas/:id(.:format)                                                      api/v3/cinemas#show {:format=>"json"}
#                                  admin_videos GET    /admin/videos(.:format)                                                         admin/videos#index
#                                               POST   /admin/videos(.:format)                                                         admin/videos#create
#                               new_admin_video GET    /admin/videos/new(.:format)                                                     admin/videos#new
#                              edit_admin_video GET    /admin/videos/:id/edit(.:format)                                                admin/videos#edit
#                                   admin_video GET    /admin/videos/:id(.:format)                                                     admin/videos#show
#                                               PATCH  /admin/videos/:id(.:format)                                                     admin/videos#update
#                                               PUT    /admin/videos/:id(.:format)                                                     admin/videos#update
#                                               DELETE /admin/videos/:id(.:format)                                                     admin/videos#destroy
#         admin_award_award_specific_categories GET    /admin/awards/:award_id/award_specific_categories(.:format)                     admin/award_specific_categories#index
#                                               POST   /admin/awards/:award_id/award_specific_categories(.:format)                     admin/award_specific_categories#create
#       new_admin_award_award_specific_category GET    /admin/awards/:award_id/award_specific_categories/new(.:format)                 admin/award_specific_categories#new
#      edit_admin_award_award_specific_category GET    /admin/awards/:award_id/award_specific_categories/:id/edit(.:format)            admin/award_specific_categories#edit
#           admin_award_award_specific_category GET    /admin/awards/:award_id/award_specific_categories/:id(.:format)                 admin/award_specific_categories#show
#                                               PATCH  /admin/awards/:award_id/award_specific_categories/:id(.:format)                 admin/award_specific_categories#update
#                                               PUT    /admin/awards/:award_id/award_specific_categories/:id(.:format)                 admin/award_specific_categories#update
#                                               DELETE /admin/awards/:award_id/award_specific_categories/:id(.:format)                 admin/award_specific_categories#destroy
#                                  admin_awards GET    /admin/awards(.:format)                                                         admin/awards#index
#                                               POST   /admin/awards(.:format)                                                         admin/awards#create
#                               new_admin_award GET    /admin/awards/new(.:format)                                                     admin/awards#new
#                              edit_admin_award GET    /admin/awards/:id/edit(.:format)                                                admin/awards#edit
#                                   admin_award GET    /admin/awards/:id(.:format)                                                     admin/awards#show
#                                               PATCH  /admin/awards/:id(.:format)                                                     admin/awards#update
#                                               PUT    /admin/awards/:id(.:format)                                                     admin/awards#update
#                                               DELETE /admin/awards/:id(.:format)                                                     admin/awards#destroy
#               admin_award_specific_categories GET    /admin/award_specific_categories(.:format)                                      admin/award_specific_categories#index
#                                               POST   /admin/award_specific_categories(.:format)                                      admin/award_specific_categories#create
#             new_admin_award_specific_category GET    /admin/award_specific_categories/new(.:format)                                  admin/award_specific_categories#new
#            edit_admin_award_specific_category GET    /admin/award_specific_categories/:id/edit(.:format)                             admin/award_specific_categories#edit
#                 admin_award_specific_category GET    /admin/award_specific_categories/:id(.:format)                                  admin/award_specific_categories#show
#                                               PATCH  /admin/award_specific_categories/:id(.:format)                                  admin/award_specific_categories#update
#                                               PUT    /admin/award_specific_categories/:id(.:format)                                  admin/award_specific_categories#update
#                                               DELETE /admin/award_specific_categories/:id(.:format)                                  admin/award_specific_categories#destroy
#                        admin_award_categories GET    /admin/award_categories(.:format)                                               admin/award_categories#index
#                                               POST   /admin/award_categories(.:format)                                               admin/award_categories#create
#                      new_admin_award_category GET    /admin/award_categories/new(.:format)                                           admin/award_categories#new
#                     edit_admin_award_category GET    /admin/award_categories/:id/edit(.:format)                                      admin/award_categories#edit
#                          admin_award_category GET    /admin/award_categories/:id(.:format)                                           admin/award_categories#show
#                                               PATCH  /admin/award_categories/:id(.:format)                                           admin/award_categories#update
#                                               PUT    /admin/award_categories/:id(.:format)                                           admin/award_categories#update
#                                               DELETE /admin/award_categories/:id(.:format)                                           admin/award_categories#destroy
#                             admin_award_types GET    /admin/award_types(.:format)                                                    admin/award_types#index
#                                               POST   /admin/award_types(.:format)                                                    admin/award_types#create
#                          new_admin_award_type GET    /admin/award_types/new(.:format)                                                admin/award_types#new
#                         edit_admin_award_type GET    /admin/award_types/:id/edit(.:format)                                           admin/award_types#edit
#                              admin_award_type GET    /admin/award_types/:id(.:format)                                                admin/award_types#show
#                                               PATCH  /admin/award_types/:id(.:format)                                                admin/award_types#update
#                                               PUT    /admin/award_types/:id(.:format)                                                admin/award_types#update
#                                               DELETE /admin/award_types/:id(.:format)                                                admin/award_types#destroy
#                                admin_opinions GET    /admin/opinions(.:format)                                                       admin/opinions#index
#                                               POST   /admin/opinions(.:format)                                                       admin/opinions#create
#                             new_admin_opinion GET    /admin/opinions/new(.:format)                                                   admin/opinions#new
#                            edit_admin_opinion GET    /admin/opinions/:id/edit(.:format)                                              admin/opinions#edit
#                                 admin_opinion GET    /admin/opinions/:id(.:format)                                                   admin/opinions#show
#                                               PATCH  /admin/opinions/:id(.:format)                                                   admin/opinions#update
#                                               PUT    /admin/opinions/:id(.:format)                                                   admin/opinions#update
#                                               DELETE /admin/opinions/:id(.:format)                                                   admin/opinions#destroy
#                         admin_cinema_theaters GET    /admin/cinemas/:cinema_id/theaters(.:format)                                    admin/theaters#index
#                                               POST   /admin/cinemas/:cinema_id/theaters(.:format)                                    admin/theaters#create
#                      new_admin_cinema_theater GET    /admin/cinemas/:cinema_id/theaters/new(.:format)                                admin/theaters#new
#                     edit_admin_cinema_theater GET    /admin/cinemas/:cinema_id/theaters/:id/edit(.:format)                           admin/theaters#edit
#                          admin_cinema_theater GET    /admin/cinemas/:cinema_id/theaters/:id(.:format)                                admin/theaters#show
#                                               PATCH  /admin/cinemas/:cinema_id/theaters/:id(.:format)                                admin/theaters#update
#                                               PUT    /admin/cinemas/:cinema_id/theaters/:id(.:format)                                admin/theaters#update
#                                               DELETE /admin/cinemas/:cinema_id/theaters/:id(.:format)                                admin/theaters#destroy
#                                 admin_cinemas GET    /admin/cinemas(.:format)                                                        admin/cinemas#index
#                                               POST   /admin/cinemas(.:format)                                                        admin/cinemas#create
#                              new_admin_cinema GET    /admin/cinemas/new(.:format)                                                    admin/cinemas#new
#                             edit_admin_cinema GET    /admin/cinemas/:id/edit(.:format)                                               admin/cinemas#edit
#                                  admin_cinema PATCH  /admin/cinemas/:id(.:format)                                                    admin/cinemas#update
#                                               PUT    /admin/cinemas/:id(.:format)                                                    admin/cinemas#update
#                                               DELETE /admin/cinemas/:id(.:format)                                                    admin/cinemas#destroy
#                                         admin GET    /admin(.:format)                                                                admin/dashboard#index
#                         admin_contact_tickets GET    /admin/contact_tickets(.:format)                                                admin/contact_tickets#index
#                                               POST   /admin/contact_tickets(.:format)                                                admin/contact_tickets#create
#                          admin_contact_ticket GET    /admin/contact_tickets/:id(.:format)                                            admin/contact_tickets#show
#                                  admin_genres GET    /admin/genres(.:format)                                                         admin/genres#index
#                                               POST   /admin/genres(.:format)                                                         admin/genres#create
#                               new_admin_genre GET    /admin/genres/new(.:format)                                                     admin/genres#new
#                              edit_admin_genre GET    /admin/genres/:id/edit(.:format)                                                admin/genres#edit
#                                   admin_genre GET    /admin/genres/:id(.:format)                                                     admin/genres#show
#                                               PATCH  /admin/genres/:id(.:format)                                                     admin/genres#update
#                                               PUT    /admin/genres/:id(.:format)                                                     admin/genres#update
#                                               DELETE /admin/genres/:id(.:format)                                                     admin/genres#destroy
#                                  admin_people GET    /admin/people(.:format)                                                         admin/people#index
#                                               POST   /admin/people(.:format)                                                         admin/people#create
#                              new_admin_person GET    /admin/people/new(.:format)                                                     admin/people#new
#                             edit_admin_person GET    /admin/people/:id/edit(.:format)                                                admin/people#edit
#                                  admin_person GET    /admin/people/:id(.:format)                                                     admin/people#show
#                                               PATCH  /admin/people/:id(.:format)                                                     admin/people#update
#                                               PUT    /admin/people/:id(.:format)                                                     admin/people#update
#                                               DELETE /admin/people/:id(.:format)                                                     admin/people#destroy
#      admin_function_type_parse_detector_types GET    /admin/function_types/:function_type_id/parse_detector_types(.:format)          admin/parse_detector_types#index
#                                               POST   /admin/function_types/:function_type_id/parse_detector_types(.:format)          admin/parse_detector_types#create
#   new_admin_function_type_parse_detector_type GET    /admin/function_types/:function_type_id/parse_detector_types/new(.:format)      admin/parse_detector_types#new
#  edit_admin_function_type_parse_detector_type GET    /admin/function_types/:function_type_id/parse_detector_types/:id/edit(.:format) admin/parse_detector_types#edit
#       admin_function_type_parse_detector_type GET    /admin/function_types/:function_type_id/parse_detector_types/:id(.:format)      admin/parse_detector_types#show
#                                               PATCH  /admin/function_types/:function_type_id/parse_detector_types/:id(.:format)      admin/parse_detector_types#update
#                                               PUT    /admin/function_types/:function_type_id/parse_detector_types/:id(.:format)      admin/parse_detector_types#update
#                                               DELETE /admin/function_types/:function_type_id/parse_detector_types/:id(.:format)      admin/parse_detector_types#destroy
#                          admin_function_types GET    /admin/function_types(.:format)                                                 admin/function_types#index
#                                               POST   /admin/function_types(.:format)                                                 admin/function_types#create
#                       new_admin_function_type GET    /admin/function_types/new(.:format)                                             admin/function_types#new
#                      edit_admin_function_type GET    /admin/function_types/:id/edit(.:format)                                        admin/function_types#edit
#                           admin_function_type GET    /admin/function_types/:id(.:format)                                             admin/function_types#show
#                                               PATCH  /admin/function_types/:id(.:format)                                             admin/function_types#update
#                                               PUT    /admin/function_types/:id(.:format)                                             admin/function_types#update
#                                               DELETE /admin/function_types/:id(.:format)                                             admin/function_types#destroy
#                        admin_channel_programs GET    /admin/channels/:channel_id/programs(.:format)                                  admin/programs#index
#                                               POST   /admin/channels/:channel_id/programs(.:format)                                  admin/programs#create
#                     new_admin_channel_program GET    /admin/channels/:channel_id/programs/new(.:format)                              admin/programs#new
#                    edit_admin_channel_program GET    /admin/channels/:channel_id/programs/:id/edit(.:format)                         admin/programs#edit
#                         admin_channel_program GET    /admin/channels/:channel_id/programs/:id(.:format)                              admin/programs#show
#                                               PATCH  /admin/channels/:channel_id/programs/:id(.:format)                              admin/programs#update
#                                               PUT    /admin/channels/:channel_id/programs/:id(.:format)                              admin/programs#update
#                                               DELETE /admin/channels/:channel_id/programs/:id(.:format)                              admin/programs#destroy
#                                admin_channels GET    /admin/channels(.:format)                                                       admin/channels#index
#                                               POST   /admin/channels(.:format)                                                       admin/channels#create
#                             new_admin_channel GET    /admin/channels/new(.:format)                                                   admin/channels#new
#                            edit_admin_channel GET    /admin/channels/:id/edit(.:format)                                              admin/channels#edit
#                                 admin_channel GET    /admin/channels/:id(.:format)                                                   admin/channels#show
#                                               PATCH  /admin/channels/:id(.:format)                                                   admin/channels#update
#                                               PUT    /admin/channels/:id(.:format)                                                   admin/channels#update
#                                               DELETE /admin/channels/:id(.:format)                                                   admin/channels#destroy
#                          admin_country_cities GET    /admin/countries/:country_id/cities(.:format)                                   admin/cities#index
#                                               POST   /admin/countries/:country_id/cities(.:format)                                   admin/cities#create
#                        new_admin_country_city GET    /admin/countries/:country_id/cities/new(.:format)                               admin/cities#new
#                       edit_admin_country_city GET    /admin/countries/:country_id/cities/:id/edit(.:format)                          admin/cities#edit
#                            admin_country_city GET    /admin/countries/:country_id/cities/:id(.:format)                               admin/cities#show
#                                               PATCH  /admin/countries/:country_id/cities/:id(.:format)                               admin/cities#update
#                                               PUT    /admin/countries/:country_id/cities/:id(.:format)                               admin/cities#update
#                                               DELETE /admin/countries/:country_id/cities/:id(.:format)                               admin/cities#destroy
#                               admin_countries GET    /admin/countries(.:format)                                                      admin/countries#index
#                                               POST   /admin/countries(.:format)                                                      admin/countries#create
#                             new_admin_country GET    /admin/countries/new(.:format)                                                  admin/countries#new
#                            edit_admin_country GET    /admin/countries/:id/edit(.:format)                                             admin/countries#edit
#                                 admin_country GET    /admin/countries/:id(.:format)                                                  admin/countries#show
#                                               PATCH  /admin/countries/:id(.:format)                                                  admin/countries#update
#                                               PUT    /admin/countries/:id(.:format)                                                  admin/countries#update
#                                               DELETE /admin/countries/:id(.:format)                                                  admin/countries#destroy
#                           admin_city_theaters GET    /admin/cities/:city_id/theaters(.:format)                                       admin/theaters#index
#                                               POST   /admin/cities/:city_id/theaters(.:format)                                       admin/theaters#create
#                        new_admin_city_theater GET    /admin/cities/:city_id/theaters/new(.:format)                                   admin/theaters#new
#                       edit_admin_city_theater GET    /admin/cities/:city_id/theaters/:id/edit(.:format)                              admin/theaters#edit
#                            admin_city_theater GET    /admin/cities/:city_id/theaters/:id(.:format)                                   admin/theaters#show
#                                               PATCH  /admin/cities/:city_id/theaters/:id(.:format)                                   admin/theaters#update
#                                               PUT    /admin/cities/:city_id/theaters/:id(.:format)                                   admin/theaters#update
#                                               DELETE /admin/cities/:city_id/theaters/:id(.:format)                                   admin/theaters#destroy
#                                  admin_cities GET    /admin/cities(.:format)                                                         admin/cities#index
#                                               POST   /admin/cities(.:format)                                                         admin/cities#create
#                                new_admin_city GET    /admin/cities/new(.:format)                                                     admin/cities#new
#                               edit_admin_city GET    /admin/cities/:id/edit(.:format)                                                admin/cities#edit
#                                    admin_city GET    /admin/cities/:id(.:format)                                                     admin/cities#show
#                                               PATCH  /admin/cities/:id(.:format)                                                     admin/cities#update
#                                               PUT    /admin/cities/:id(.:format)                                                     admin/cities#update
#                                               DELETE /admin/cities/:id(.:format)                                                     admin/cities#destroy
#             new_parse_admin_theater_functions GET    /admin/theaters/:theater_id/functions/new_parse(.:format)                       admin/functions#new_parse
#          create_parse_admin_theater_functions POST   /admin/theaters/:theater_id/functions/create_parse(.:format)                    admin/functions#create_parse
#     create_ajax_parse_admin_theater_functions POST   /admin/theaters/:theater_id/functions/create_ajax_parse(.:format)               admin/functions#create_ajax_parse
# functions_delete_week_admin_theater_functions POST   /admin/theaters/:theater_id/functions/delete_week(.:format)                     admin/functions#delete_week
#  functions_delete_day_admin_theater_functions POST   /admin/theaters/:theater_id/functions/delete_day(.:format)                      admin/functions#delete_day
#        functions_copy_admin_theater_functions POST   /admin/theaters/:theater_id/functions/copy_last_day(.:format)                   admin/functions#copy_last_day
#        new_parse_ajax_admin_theater_functions POST   /admin/theaters/:theater_id/functions/new_parse_ajax(.:format)                  admin/functions#new_parse_ajax
#                       admin_theater_functions GET    /admin/theaters/:theater_id/functions(.:format)                                 admin/functions#index
#                                               POST   /admin/theaters/:theater_id/functions(.:format)                                 admin/functions#create
#                    new_admin_theater_function GET    /admin/theaters/:theater_id/functions/new(.:format)                             admin/functions#new
#                   edit_admin_theater_function GET    /admin/theaters/:theater_id/functions/:id/edit(.:format)                        admin/functions#edit
#                        admin_theater_function GET    /admin/theaters/:theater_id/functions/:id(.:format)                             admin/functions#show
#                                               PATCH  /admin/theaters/:theater_id/functions/:id(.:format)                             admin/functions#update
#                                               PUT    /admin/theaters/:theater_id/functions/:id(.:format)                             admin/functions#update
#                                               DELETE /admin/theaters/:theater_id/functions/:id(.:format)                             admin/functions#destroy
#                                admin_theaters GET    /admin/theaters(.:format)                                                       admin/theaters#index
#                                               POST   /admin/theaters(.:format)                                                       admin/theaters#create
#                             new_admin_theater GET    /admin/theaters/new(.:format)                                                   admin/theaters#new
#                            edit_admin_theater GET    /admin/theaters/:id/edit(.:format)                                              admin/theaters#edit
#                                 admin_theater GET    /admin/theaters/:id(.:format)                                                   admin/theaters#show
#                                               PATCH  /admin/theaters/:id(.:format)                                                   admin/theaters#update
#                                               PUT    /admin/theaters/:id(.:format)                                                   admin/theaters#update
#                                               DELETE /admin/theaters/:id(.:format)                                                   admin/theaters#destroy
#                         billboard_admin_shows GET    /admin/shows/billboard(.:format)                                                admin/shows#billboard
#                        comingsoon_admin_shows GET    /admin/shows/comingsoon(.:format)                                               admin/shows#comingsoon
#                                   admin_shows GET    /admin/shows(.:format)                                                          admin/shows#index
#                                               POST   /admin/shows(.:format)                                                          admin/shows#create
#                                new_admin_show GET    /admin/shows/new(.:format)                                                      admin/shows#new
#                               edit_admin_show GET    /admin/shows/:id/edit(.:format)                                                 admin/shows#edit
#                                    admin_show GET    /admin/shows/:id(.:format)                                                      admin/shows#show
#                                               PATCH  /admin/shows/:id(.:format)                                                      admin/shows#update
#                                               PUT    /admin/shows/:id(.:format)                                                      admin/shows#update
#                                               DELETE /admin/shows/:id(.:format)                                                      admin/shows#destroy
#                  admin_show_person_roles_sort POST   /admin/show_person_roles/sort(.:format)                                         admin/show_person_roles#sort
#                                admin_settings GET    /admin/settings(.:format)                                                       admin/settings#index
#                            edit_admin_setting GET    /admin/settings/:id/edit(.:format)                                              admin/settings#edit
#                                 admin_setting PATCH  /admin/settings/:id(.:format)                                                   admin/settings#update
#                                               PUT    /admin/settings/:id(.:format)                                                   admin/settings#update
#                                               GET    /*unmatched_route(.:format)                                                     application#raise_route_not_found!
#

require 'api_constraints'

Webcinehorarios::Application.routes.draw do
  
  devise_for :members

  root :to => 'home#index'

  ##### API #####
  namespace :api, defaults: { format: 'json' } do
    
    ##### V3 #####
    scope module: :v3, constraints: ApiConstraints.new(version: 3, default: true) do
      
      resources :shows, only: :show do
        collection do 
          get 'billboard'
          get 'comingsoon'
          get ':show_id/show_theaters' => 'theaters#show_theaters'
          get ':show_id/favorite_theaters' => 'theaters#favorite_theaters'
          get ':show_id/show_functions' => 'functions#show_functions'
        end
      end
      
      resources :awards, only: :index
      
      resources :videos, only: :index
      
      resources :theaters, only: [:index, :show] do
        resources :functions, only: :index
        collection do
          get 'theater_coordinates'
        end
      end
      resources :cinemas, only: [:show] do
        resources :theaters, only: :index do
        end
      end
    end
    
    ##### V4 #####
    scope module: :v4, constraints: ApiConstraints.new(version: 4) do
      
      resources :theaters, only: :index do
        resources :functions, only: :index
      end
      
      resources :videos, only: :index
      
      resources :shows, only: :show do
        collection do
          get 'billboard'
          get 'coming_soon'
        end
        get 'theaters'
      end
      
    end
    
  end
  
  # ADMIN
  namespace :admin do
    
    resources :videos
    resources :awards do
      resources :award_specific_categories
    end
    resources :award_specific_categories
    resources :award_categories
    resources :award_types
        
    resources :opinions

    resources :cinemas, except: :show do
      resources :theaters
    end
    
    get '' => 'dashboard#index', as: '/'
    resources :contact_tickets, only: [:index, :show, :create]
    resources :genres
    resources :people do
      collection do
        get 'select_people'
      end
    end
    
    resources :function_types do
      resources :parse_detector_types
    end

    resources :channels do
      resources :programs
    end
    resources :countries do
      resources :cities
    end
    resources :cities do
      resources :theaters
    end
    resources :theaters do
      resources :functions do
        collection do
          get :parse_theater
          get 'new_parse'
          post 'create_parse'
          post 'create_ajax_parse'
          post 'delete_week', as: 'functions_delete_week'
          post 'delete_day', as: 'functions_delete_day'
          post 'copy_last_day', as: 'functions_copy'
          post 'new_parse_ajax'
        end
      end
    end
    resources :shows do
      get 'simple_show'
      collection do 
        get 'billboard'
        get 'comingsoon'
        get 'select_shows'
      end 
    end
    # For Sorting Actors
    post 'show_person_roles/sort' => 'show_person_roles#sort', as: 'show_person_roles_sort'
    
    get 'orphan_parsed_shows' => 'functions#orphan_parsed_shows'
    post 'create_parsed_shows' => 'functions#create_parsed_shows'
    
    resources :settings, only: [:index, :edit, :update]
  end
  
  get '*unmatched_route', :to => 'application#raise_route_not_found!'
end
