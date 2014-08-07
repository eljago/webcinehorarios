# == Route Map
#
#                           new_member_session GET    /members/sign_in(.:format)                                                      devise/sessions#new
#                               member_session POST   /members/sign_in(.:format)                                                      devise/sessions#create
#                       destroy_member_session DELETE /members/sign_out(.:format)                                                     devise/sessions#destroy
#                              member_password POST   /members/password(.:format)                                                     devise/passwords#create
#                          new_member_password GET    /members/password/new(.:format)                                                 devise/passwords#new
#                         edit_member_password GET    /members/password/edit(.:format)                                                devise/passwords#edit
#                                              PUT    /members/password(.:format)                                                     devise/passwords#update
#                   cancel_member_registration GET    /members/cancel(.:format)                                                       devise/registrations#cancel
#                          member_registration POST   /members(.:format)                                                              devise/registrations#create
#                      new_member_registration GET    /members/sign_up(.:format)                                                      devise/registrations#new
#                     edit_member_registration GET    /members/edit(.:format)                                                         devise/registrations#edit
#                                              PUT    /members(.:format)                                                              devise/registrations#update
#                                              DELETE /members(.:format)                                                              devise/registrations#destroy
#                                         root        /                                                                               home#index
#                                  sidekiq_web        /sidekiq                                                                        Sidekiq::Web
#                                 api_register POST   /api/registrations(.:format)                                                    api/v4/registrations#create {:format=>"json"}
#                                    api_login POST   /api/sessions(.:format)                                                         api/v4/sessions#create {:format=>"json"}
#                                   api_logout DELETE /api/sessions(.:format)                                                         api/v4/sessions#destroy {:format=>"json"}
#                          billboard_api_shows GET    /api/shows/billboard(.:format)                                                  api/v4/shows#billboard {:format=>"json"}
#                         comingsoon_api_shows GET    /api/shows/comingsoon(.:format)                                                 api/v4/shows#comingsoon {:format=>"json"}
#                                              GET    /api/shows/:show_id/show_theaters(.:format)                                     api/v4/theaters#show_theaters {:format=>"json"}
#                                              GET    /api/shows/:show_id/favorite_theaters(.:format)                                 api/v4/theaters#favorite_theaters {:format=>"json"}
#                                              GET    /api/shows/:show_id/show_functions(.:format)                                    api/v4/functions#show_functions {:format=>"json"}
#                                     api_show GET    /api/shows/:id(.:format)                                                        api/v4/shows#show {:format=>"json"}
#                                   api_awards GET    /api/awards(.:format)                                                           api/v4/awards#index {:format=>"json"}
#                                   api_videos GET    /api/videos(.:format)                                                           api/v4/videos#index {:format=>"json"}
#                        api_theater_functions GET    /api/theaters/:theater_id/functions(.:format)                                   api/v4/functions#index {:format=>"json"}
#             theater_coordinates_api_theaters GET    /api/theaters/theater_coordinates(.:format)                                     api/v4/theaters#theater_coordinates {:format=>"json"}
#                                  api_theater GET    /api/theaters/:id(.:format)                                                     api/v4/theaters#show {:format=>"json"}
#                          api_cinema_theaters GET    /api/cinemas/:cinema_id/theaters(.:format)                                      api/v4/theaters#index {:format=>"json"}
#                                   api_cinema GET    /api/cinemas/:id(.:format)                                                      api/v4/cinemas#show {:format=>"json"}
#                                          api        /api/*unmatched_route(.:format)                                                 api/v4/api#api_route_not_found! {:format=>"json"}
#                                 api_register POST   /api/registrations(.:format)                                                    api/v3/registrations#create {:format=>"json"}
#                                    api_login POST   /api/sessions(.:format)                                                         api/v3/sessions#create {:format=>"json"}
#                                   api_logout DELETE /api/sessions(.:format)                                                         api/v3/sessions#destroy {:format=>"json"}
#                                              GET    /api/shows/billboard(.:format)                                                  api/v3/shows#billboard {:format=>"json"}
#                                              GET    /api/shows/comingsoon(.:format)                                                 api/v3/shows#comingsoon {:format=>"json"}
#                                              GET    /api/shows/:show_id/show_theaters(.:format)                                     api/v3/theaters#show_theaters {:format=>"json"}
#                                              GET    /api/shows/:show_id/favorite_theaters(.:format)                                 api/v3/theaters#favorite_theaters {:format=>"json"}
#                                              GET    /api/shows/:show_id/show_functions(.:format)                                    api/v3/functions#show_functions {:format=>"json"}
#                                              GET    /api/shows/:id(.:format)                                                        api/v3/shows#show {:format=>"json"}
#                                              GET    /api/awards(.:format)                                                           api/v3/awards#index {:format=>"json"}
#                                              GET    /api/videos(.:format)                                                           api/v3/videos#index {:format=>"json"}
#                                              GET    /api/theaters/:theater_id/functions(.:format)                                   api/v3/functions#index {:format=>"json"}
#                                              GET    /api/theaters/theater_coordinates(.:format)                                     api/v3/theaters#theater_coordinates {:format=>"json"}
#                                              GET    /api/theaters/:id(.:format)                                                     api/v3/theaters#show {:format=>"json"}
#                                              GET    /api/cinemas/:cinema_id/theaters(.:format)                                      api/v3/theaters#index {:format=>"json"}
#                                              GET    /api/cinemas/:id(.:format)                                                      api/v3/cinemas#show {:format=>"json"}
#                                              GET    /api/shows/billboard(.:format)                                                  api/v2/shows#billboard {:format=>"json"}
#                                              GET    /api/shows/comingsoon(.:format)                                                 api/v2/shows#comingsoon {:format=>"json"}
#                                              GET    /api/shows/:show_id/show_theaters(.:format)                                     api/v2/theaters#show_theaters {:format=>"json"}
#                                              GET    /api/shows/:show_id/favorite_theaters(.:format)                                 api/v2/theaters#favorite_theaters {:format=>"json"}
#                                              GET    /api/shows/:show_id/show_functions(.:format)                                    api/v2/functions#show_functions {:format=>"json"}
#                                              GET    /api/shows/:id(.:format)                                                        api/v2/shows#show {:format=>"json"}
#                                              GET    /api/videos(.:format)                                                           api/v2/videos#index {:format=>"json"}
#                                              GET    /api/theaters/:theater_id/functions(.:format)                                   api/v2/functions#index {:format=>"json"}
#                                              GET    /api/theaters/theater_coordinates(.:format)                                     api/v2/theaters#theater_coordinates {:format=>"json"}
#                                              GET    /api/cinemas/:cinema_id/theaters(.:format)                                      api/v2/theaters#index {:format=>"json"}
#                                              GET    /api/cinemas/:id(.:format)                                                      api/v1/cinemas#show {:format=>"json"}
#                                api_billboard GET    /api/billboard(.:format)                                                        api/v1/shows#billboard {:format=>"json"}
#                                api_premieres GET    /api/premieres(.:format)                                                        api/v1/shows#premieres {:format=>"json"}
#                               api_comingsoon GET    /api/comingsoon(.:format)                                                       api/v1/shows#comingsoon {:format=>"json"}
#                      api_show_show_functions GET    /api/shows/:show_id/show_functions(.:format)                                    api/v1/functions#show_functions {:format=>"json"}
#                 api_show_show_theaters_joins GET    /api/shows/:show_id/show_theaters_joins(.:format)                               api/v1/theaters#show_theaters_joins {:format=>"json"}
#                                              GET    /api/shows/:id(.:format)                                                        api/v1/shows#show {:format=>"json"}
#                           api_country_cities GET    /api/countries/:country_id/cities(.:format)                                     api/v1/cities#index {:format=>"json"}
#                                              GET    /api/theaters/:theater_id/functions(.:format)                                   api/v1/functions#index {:format=>"json"}
#                                 admin_videos GET    /admin/videos(.:format)                                                         admin/videos#index
#                                              POST   /admin/videos(.:format)                                                         admin/videos#create
#                              new_admin_video GET    /admin/videos/new(.:format)                                                     admin/videos#new
#                             edit_admin_video GET    /admin/videos/:id/edit(.:format)                                                admin/videos#edit
#                                  admin_video GET    /admin/videos/:id(.:format)                                                     admin/videos#show
#                                              PUT    /admin/videos/:id(.:format)                                                     admin/videos#update
#                                              DELETE /admin/videos/:id(.:format)                                                     admin/videos#destroy
#        admin_award_award_specific_categories GET    /admin/awards/:award_id/award_specific_categories(.:format)                     admin/award_specific_categories#index
#                                              POST   /admin/awards/:award_id/award_specific_categories(.:format)                     admin/award_specific_categories#create
#      new_admin_award_award_specific_category GET    /admin/awards/:award_id/award_specific_categories/new(.:format)                 admin/award_specific_categories#new
#     edit_admin_award_award_specific_category GET    /admin/awards/:award_id/award_specific_categories/:id/edit(.:format)            admin/award_specific_categories#edit
#          admin_award_award_specific_category GET    /admin/awards/:award_id/award_specific_categories/:id(.:format)                 admin/award_specific_categories#show
#                                              PUT    /admin/awards/:award_id/award_specific_categories/:id(.:format)                 admin/award_specific_categories#update
#                                              DELETE /admin/awards/:award_id/award_specific_categories/:id(.:format)                 admin/award_specific_categories#destroy
#                                 admin_awards GET    /admin/awards(.:format)                                                         admin/awards#index
#                                              POST   /admin/awards(.:format)                                                         admin/awards#create
#                              new_admin_award GET    /admin/awards/new(.:format)                                                     admin/awards#new
#                             edit_admin_award GET    /admin/awards/:id/edit(.:format)                                                admin/awards#edit
#                                  admin_award GET    /admin/awards/:id(.:format)                                                     admin/awards#show
#                                              PUT    /admin/awards/:id(.:format)                                                     admin/awards#update
#                                              DELETE /admin/awards/:id(.:format)                                                     admin/awards#destroy
#              admin_award_specific_categories GET    /admin/award_specific_categories(.:format)                                      admin/award_specific_categories#index
#                                              POST   /admin/award_specific_categories(.:format)                                      admin/award_specific_categories#create
#            new_admin_award_specific_category GET    /admin/award_specific_categories/new(.:format)                                  admin/award_specific_categories#new
#           edit_admin_award_specific_category GET    /admin/award_specific_categories/:id/edit(.:format)                             admin/award_specific_categories#edit
#                admin_award_specific_category GET    /admin/award_specific_categories/:id(.:format)                                  admin/award_specific_categories#show
#                                              PUT    /admin/award_specific_categories/:id(.:format)                                  admin/award_specific_categories#update
#                                              DELETE /admin/award_specific_categories/:id(.:format)                                  admin/award_specific_categories#destroy
#                       admin_award_categories GET    /admin/award_categories(.:format)                                               admin/award_categories#index
#                                              POST   /admin/award_categories(.:format)                                               admin/award_categories#create
#                     new_admin_award_category GET    /admin/award_categories/new(.:format)                                           admin/award_categories#new
#                    edit_admin_award_category GET    /admin/award_categories/:id/edit(.:format)                                      admin/award_categories#edit
#                         admin_award_category GET    /admin/award_categories/:id(.:format)                                           admin/award_categories#show
#                                              PUT    /admin/award_categories/:id(.:format)                                           admin/award_categories#update
#                                              DELETE /admin/award_categories/:id(.:format)                                           admin/award_categories#destroy
#                            admin_award_types GET    /admin/award_types(.:format)                                                    admin/award_types#index
#                                              POST   /admin/award_types(.:format)                                                    admin/award_types#create
#                         new_admin_award_type GET    /admin/award_types/new(.:format)                                                admin/award_types#new
#                        edit_admin_award_type GET    /admin/award_types/:id/edit(.:format)                                           admin/award_types#edit
#                             admin_award_type GET    /admin/award_types/:id(.:format)                                                admin/award_types#show
#                                              PUT    /admin/award_types/:id(.:format)                                                admin/award_types#update
#                                              DELETE /admin/award_types/:id(.:format)                                                admin/award_types#destroy
#                               admin_opinions GET    /admin/opinions(.:format)                                                       admin/opinions#index
#                                              POST   /admin/opinions(.:format)                                                       admin/opinions#create
#                            new_admin_opinion GET    /admin/opinions/new(.:format)                                                   admin/opinions#new
#                           edit_admin_opinion GET    /admin/opinions/:id/edit(.:format)                                              admin/opinions#edit
#                                admin_opinion GET    /admin/opinions/:id(.:format)                                                   admin/opinions#show
#                                              PUT    /admin/opinions/:id(.:format)                                                   admin/opinions#update
#                                              DELETE /admin/opinions/:id(.:format)                                                   admin/opinions#destroy
#                        admin_cinema_theaters GET    /admin/cinemas/:cinema_id/theaters(.:format)                                    admin/theaters#index
#                                              POST   /admin/cinemas/:cinema_id/theaters(.:format)                                    admin/theaters#create
#                     new_admin_cinema_theater GET    /admin/cinemas/:cinema_id/theaters/new(.:format)                                admin/theaters#new
#                    edit_admin_cinema_theater GET    /admin/cinemas/:cinema_id/theaters/:id/edit(.:format)                           admin/theaters#edit
#                         admin_cinema_theater GET    /admin/cinemas/:cinema_id/theaters/:id(.:format)                                admin/theaters#show
#                                              PUT    /admin/cinemas/:cinema_id/theaters/:id(.:format)                                admin/theaters#update
#                                              DELETE /admin/cinemas/:cinema_id/theaters/:id(.:format)                                admin/theaters#destroy
#                                admin_cinemas GET    /admin/cinemas(.:format)                                                        admin/cinemas#index
#                                              POST   /admin/cinemas(.:format)                                                        admin/cinemas#create
#                             new_admin_cinema GET    /admin/cinemas/new(.:format)                                                    admin/cinemas#new
#                            edit_admin_cinema GET    /admin/cinemas/:id/edit(.:format)                                               admin/cinemas#edit
#                                 admin_cinema PUT    /admin/cinemas/:id(.:format)                                                    admin/cinemas#update
#                                              DELETE /admin/cinemas/:id(.:format)                                                    admin/cinemas#destroy
#                                        admin GET    /admin(.:format)                                                                admin/dashboard#index
#                        admin_contact_tickets GET    /admin/contact_tickets(.:format)                                                admin/contact_tickets#index
#                                              POST   /admin/contact_tickets(.:format)                                                admin/contact_tickets#create
#                         admin_contact_ticket GET    /admin/contact_tickets/:id(.:format)                                            admin/contact_tickets#show
#                                 admin_genres GET    /admin/genres(.:format)                                                         admin/genres#index
#                                              POST   /admin/genres(.:format)                                                         admin/genres#create
#                              new_admin_genre GET    /admin/genres/new(.:format)                                                     admin/genres#new
#                             edit_admin_genre GET    /admin/genres/:id/edit(.:format)                                                admin/genres#edit
#                                  admin_genre GET    /admin/genres/:id(.:format)                                                     admin/genres#show
#                                              PUT    /admin/genres/:id(.:format)                                                     admin/genres#update
#                                              DELETE /admin/genres/:id(.:format)                                                     admin/genres#destroy
#                                 admin_people GET    /admin/people(.:format)                                                         admin/people#index
#                                              POST   /admin/people(.:format)                                                         admin/people#create
#                             new_admin_person GET    /admin/people/new(.:format)                                                     admin/people#new
#                            edit_admin_person GET    /admin/people/:id/edit(.:format)                                                admin/people#edit
#                                 admin_person GET    /admin/people/:id(.:format)                                                     admin/people#show
#                                              PUT    /admin/people/:id(.:format)                                                     admin/people#update
#                                              DELETE /admin/people/:id(.:format)                                                     admin/people#destroy
#     admin_function_type_parse_detector_types GET    /admin/function_types/:function_type_id/parse_detector_types(.:format)          admin/parse_detector_types#index
#                                              POST   /admin/function_types/:function_type_id/parse_detector_types(.:format)          admin/parse_detector_types#create
#  new_admin_function_type_parse_detector_type GET    /admin/function_types/:function_type_id/parse_detector_types/new(.:format)      admin/parse_detector_types#new
# edit_admin_function_type_parse_detector_type GET    /admin/function_types/:function_type_id/parse_detector_types/:id/edit(.:format) admin/parse_detector_types#edit
#      admin_function_type_parse_detector_type GET    /admin/function_types/:function_type_id/parse_detector_types/:id(.:format)      admin/parse_detector_types#show
#                                              PUT    /admin/function_types/:function_type_id/parse_detector_types/:id(.:format)      admin/parse_detector_types#update
#                                              DELETE /admin/function_types/:function_type_id/parse_detector_types/:id(.:format)      admin/parse_detector_types#destroy
#                         admin_function_types GET    /admin/function_types(.:format)                                                 admin/function_types#index
#                                              POST   /admin/function_types(.:format)                                                 admin/function_types#create
#                      new_admin_function_type GET    /admin/function_types/new(.:format)                                             admin/function_types#new
#                     edit_admin_function_type GET    /admin/function_types/:id/edit(.:format)                                        admin/function_types#edit
#                          admin_function_type GET    /admin/function_types/:id(.:format)                                             admin/function_types#show
#                                              PUT    /admin/function_types/:id(.:format)                                             admin/function_types#update
#                                              DELETE /admin/function_types/:id(.:format)                                             admin/function_types#destroy
#                       admin_channel_programs GET    /admin/channels/:channel_id/programs(.:format)                                  admin/programs#index
#                                              POST   /admin/channels/:channel_id/programs(.:format)                                  admin/programs#create
#                    new_admin_channel_program GET    /admin/channels/:channel_id/programs/new(.:format)                              admin/programs#new
#                   edit_admin_channel_program GET    /admin/channels/:channel_id/programs/:id/edit(.:format)                         admin/programs#edit
#                        admin_channel_program GET    /admin/channels/:channel_id/programs/:id(.:format)                              admin/programs#show
#                                              PUT    /admin/channels/:channel_id/programs/:id(.:format)                              admin/programs#update
#                                              DELETE /admin/channels/:channel_id/programs/:id(.:format)                              admin/programs#destroy
#                               admin_channels GET    /admin/channels(.:format)                                                       admin/channels#index
#                                              POST   /admin/channels(.:format)                                                       admin/channels#create
#                            new_admin_channel GET    /admin/channels/new(.:format)                                                   admin/channels#new
#                           edit_admin_channel GET    /admin/channels/:id/edit(.:format)                                              admin/channels#edit
#                                admin_channel GET    /admin/channels/:id(.:format)                                                   admin/channels#show
#                                              PUT    /admin/channels/:id(.:format)                                                   admin/channels#update
#                                              DELETE /admin/channels/:id(.:format)                                                   admin/channels#destroy
#                         admin_country_cities GET    /admin/countries/:country_id/cities(.:format)                                   admin/cities#index
#                                              POST   /admin/countries/:country_id/cities(.:format)                                   admin/cities#create
#                       new_admin_country_city GET    /admin/countries/:country_id/cities/new(.:format)                               admin/cities#new
#                      edit_admin_country_city GET    /admin/countries/:country_id/cities/:id/edit(.:format)                          admin/cities#edit
#                           admin_country_city GET    /admin/countries/:country_id/cities/:id(.:format)                               admin/cities#show
#                                              PUT    /admin/countries/:country_id/cities/:id(.:format)                               admin/cities#update
#                                              DELETE /admin/countries/:country_id/cities/:id(.:format)                               admin/cities#destroy
#                              admin_countries GET    /admin/countries(.:format)                                                      admin/countries#index
#                                              POST   /admin/countries(.:format)                                                      admin/countries#create
#                            new_admin_country GET    /admin/countries/new(.:format)                                                  admin/countries#new
#                           edit_admin_country GET    /admin/countries/:id/edit(.:format)                                             admin/countries#edit
#                                admin_country GET    /admin/countries/:id(.:format)                                                  admin/countries#show
#                                              PUT    /admin/countries/:id(.:format)                                                  admin/countries#update
#                                              DELETE /admin/countries/:id(.:format)                                                  admin/countries#destroy
#                          admin_city_theaters GET    /admin/cities/:city_id/theaters(.:format)                                       admin/theaters#index
#                                              POST   /admin/cities/:city_id/theaters(.:format)                                       admin/theaters#create
#                       new_admin_city_theater GET    /admin/cities/:city_id/theaters/new(.:format)                                   admin/theaters#new
#                      edit_admin_city_theater GET    /admin/cities/:city_id/theaters/:id/edit(.:format)                              admin/theaters#edit
#                           admin_city_theater GET    /admin/cities/:city_id/theaters/:id(.:format)                                   admin/theaters#show
#                                              PUT    /admin/cities/:city_id/theaters/:id(.:format)                                   admin/theaters#update
#                                              DELETE /admin/cities/:city_id/theaters/:id(.:format)                                   admin/theaters#destroy
#                                 admin_cities GET    /admin/cities(.:format)                                                         admin/cities#index
#                                              POST   /admin/cities(.:format)                                                         admin/cities#create
#                               new_admin_city GET    /admin/cities/new(.:format)                                                     admin/cities#new
#                              edit_admin_city GET    /admin/cities/:id/edit(.:format)                                                admin/cities#edit
#                                   admin_city GET    /admin/cities/:id(.:format)                                                     admin/cities#show
#                                              PUT    /admin/cities/:id(.:format)                                                     admin/cities#update
#                                              DELETE /admin/cities/:id(.:format)                                                     admin/cities#destroy
#                      admin_theater_functions GET    /admin/theaters/:theater_id/functions(.:format)                                 admin/functions#index
#                                              POST   /admin/theaters/:theater_id/functions(.:format)                                 admin/functions#create
#                   new_admin_theater_function GET    /admin/theaters/:theater_id/functions/new(.:format)                             admin/functions#new
#                  edit_admin_theater_function GET    /admin/theaters/:theater_id/functions/:id/edit(.:format)                        admin/functions#edit
#                       admin_theater_function GET    /admin/theaters/:theater_id/functions/:id(.:format)                             admin/functions#show
#                                              PUT    /admin/theaters/:theater_id/functions/:id(.:format)                             admin/functions#update
#                                              DELETE /admin/theaters/:theater_id/functions/:id(.:format)                             admin/functions#destroy
#                      admin_theater_new_parse GET    /admin/theaters/:theater_id/new_parse(.:format)                                 admin/functions#new_parse
#                   admin_theater_create_parse PUT    /admin/theaters/:theater_id/create_parse(.:format)                              admin/functions#create_parse
#                 admin_theater_new_parse_ajax POST   /admin/theaters/:theater_id/functions/new_parse_ajax(.:format)                  admin/functions#new_parse_ajax
#              admin_theater_create_ajax_parse PUT    /admin/theaters/:theater_id/create_ajax_parse(.:format)                         admin/functions#create_ajax_parse
#                 admin_theater_functions_copy POST   /admin/theaters/:theater_id/functions/copy_last_day(.:format)                   admin/functions#copy_last_day
#           admin_theater_functions_delete_day POST   /admin/theaters/:theater_id/functions/delete_day(.:format)                      admin/functions#delete_day
#          admin_theater_functions_delete_week POST   /admin/theaters/:theater_id/functions/delete_week(.:format)                     admin/functions#delete_week
#                               admin_theaters GET    /admin/theaters(.:format)                                                       admin/theaters#index
#                                              POST   /admin/theaters(.:format)                                                       admin/theaters#create
#                            new_admin_theater GET    /admin/theaters/new(.:format)                                                   admin/theaters#new
#                           edit_admin_theater GET    /admin/theaters/:id/edit(.:format)                                              admin/theaters#edit
#                                admin_theater GET    /admin/theaters/:id(.:format)                                                   admin/theaters#show
#                                              PUT    /admin/theaters/:id(.:format)                                                   admin/theaters#update
#                                              DELETE /admin/theaters/:id(.:format)                                                   admin/theaters#destroy
#                        billboard_admin_shows GET    /admin/shows/billboard(.:format)                                                admin/shows#billboard
#                       comingsoon_admin_shows GET    /admin/shows/comingsoon(.:format)                                               admin/shows#comingsoon
#                          admin_show_comments GET    /admin/shows/:show_id/comments(.:format)                                        admin/comments#index
#                            admin_show_images GET    /admin/shows/:show_id/images(.:format)                                          admin/images#index
#                                              POST   /admin/shows/:show_id/images(.:format)                                          admin/images#create
#                         new_admin_show_image GET    /admin/shows/:show_id/images/new(.:format)                                      admin/images#new
#                        edit_admin_show_image GET    /admin/shows/:show_id/images/:id/edit(.:format)                                 admin/images#edit
#                             admin_show_image GET    /admin/shows/:show_id/images/:id(.:format)                                      admin/images#show
#                                              PUT    /admin/shows/:show_id/images/:id(.:format)                                      admin/images#update
#                                              DELETE /admin/shows/:show_id/images/:id(.:format)                                      admin/images#destroy
#                         admin_show_functions GET    /admin/shows/:show_id/functions(.:format)                                       admin/functions#index
#                                              POST   /admin/shows/:show_id/functions(.:format)                                       admin/functions#create
#                      new_admin_show_function GET    /admin/shows/:show_id/functions/new(.:format)                                   admin/functions#new
#                     edit_admin_show_function GET    /admin/shows/:show_id/functions/:id/edit(.:format)                              admin/functions#edit
#                          admin_show_function GET    /admin/shows/:show_id/functions/:id(.:format)                                   admin/functions#show
#                                              PUT    /admin/shows/:show_id/functions/:id(.:format)                                   admin/functions#update
#                                              DELETE /admin/shows/:show_id/functions/:id(.:format)                                   admin/functions#destroy
#                            admin_show_videos GET    /admin/shows/:show_id/videos(.:format)                                          admin/videos#index
#                                              POST   /admin/shows/:show_id/videos(.:format)                                          admin/videos#create
#                         new_admin_show_video GET    /admin/shows/:show_id/videos/new(.:format)                                      admin/videos#new
#                        edit_admin_show_video GET    /admin/shows/:show_id/videos/:id/edit(.:format)                                 admin/videos#edit
#                             admin_show_video GET    /admin/shows/:show_id/videos/:id(.:format)                                      admin/videos#show
#                                              PUT    /admin/shows/:show_id/videos/:id(.:format)                                      admin/videos#update
#                                              DELETE /admin/shows/:show_id/videos/:id(.:format)                                      admin/videos#destroy
#                    admin_show_functions_copy POST   /admin/shows/:show_id/functions/copy_last_day(.:format)                         admin/functions#copy_last_day
#                                  admin_shows GET    /admin/shows(.:format)                                                          admin/shows#index
#                                              POST   /admin/shows(.:format)                                                          admin/shows#create
#                               new_admin_show GET    /admin/shows/new(.:format)                                                      admin/shows#new
#                              edit_admin_show GET    /admin/shows/:id/edit(.:format)                                                 admin/shows#edit
#                                   admin_show GET    /admin/shows/:id(.:format)                                                      admin/shows#show
#                                              PUT    /admin/shows/:id(.:format)                                                      admin/shows#update
#                                              DELETE /admin/shows/:id(.:format)                                                      admin/shows#destroy
#                 admin_show_person_roles_sort POST   /admin/show_person_roles/sort(.:format)                                         admin/show_person_roles#sort
#                               admin_settings GET    /admin/settings(.:format)                                                       admin/settings#index
#                           edit_admin_setting GET    /admin/settings/:id/edit(.:format)                                              admin/settings#edit
#                                admin_setting PUT    /admin/settings/:id(.:format)                                                   admin/settings#update
#                                                     /*unmatched_route(.:format)                                                     application#raise_route_not_found!
#

require 'api_constraints'

Webcinehorarios::Application.routes.draw do
  
  devise_for :members

  root :to => 'home#index'
  
  mount Sidekiq::Web, at: "/sidekiq"

  ##### API #####
  namespace :api, defaults: { format: 'json' } do
    
    ##### V4 #####
    scope module: :v4, constraints: ApiConstraints.new(version: 4) do

      devise_scope :member do
        post 'registrations' => 'registrations#create', :as => 'register'
        post 'sessions' => 'sessions#create', :as => 'login'
        delete 'sessions' => 'sessions#destroy', :as => 'logout'
      end
      
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
      
      resources :theaters, only: [:show] do
        resources :functions, only: :index
        collection do
          get 'theater_coordinates'
        end
      end
      resources :cinemas, only: [:show] do
        resources :theaters, only: :index do
        end
      end

      match '*unmatched_route', :to => 'api#api_route_not_found!'
    end
    
    ##### V3 #####
    scope module: :v3, constraints: ApiConstraints.new(version: 3) do

      devise_scope :member do
        post 'registrations' => 'registrations#create', :as => 'register'
        post 'sessions' => 'sessions#create', :as => 'login'
        delete 'sessions' => 'sessions#destroy', :as => 'logout'
      end
      
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
      
      resources :theaters, only: [:show] do
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
    
    ##### V2 #####
    scope module: :v2, constraints: ApiConstraints.new(version: 2) do
      
      resources :shows, only: :show do
        collection do 
          get 'billboard'
          get 'comingsoon'
          get ':show_id/show_theaters' => 'theaters#show_theaters'
          get ':show_id/favorite_theaters' => 'theaters#favorite_theaters'
          get ':show_id/show_functions' => 'functions#show_functions'
        end
      end
      
      resources :videos, only: :index
      
      resources :theaters, only: [] do
        resources :functions, only: :index
        collection do
          get 'theater_coordinates'
        end
      end
      resources :cinemas, only: [] do
        resources :theaters, only: :index do
        end
      end
    end
    
    ##### V1 ######
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :cinemas, only: [:show]

      get 'billboard' => 'shows#billboard'
      get 'premieres' => 'shows#premieres'
      get 'comingsoon' => 'shows#comingsoon'
      
      resources :shows, only: :show do
        get 'show_functions' => 'functions#show_functions'
        get 'show_theaters_joins' => 'theaters#show_theaters_joins'
      end
      
      resources :countries, only: [] do
        resources :cities, only: :index
      end
      
      resources :theaters, only: [] do
        resources :functions, only: :index
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
    resources :genres, :people
    
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
      resources :functions
      get 'new_parse' => 'functions#new_parse'
      put 'create_parse' => 'functions#create_parse'
      post 'functions/new_parse_ajax' => 'functions#new_parse_ajax', as: 'new_parse_ajax'
      put 'create_ajax_parse' => 'functions#create_ajax_parse'
      post 'functions/copy_last_day' => 'functions#copy_last_day', as: 'functions_copy'
      post 'functions/delete_day' => 'functions#delete_day', as: 'functions_delete_day'
      post 'functions/delete_week' => 'functions#delete_week', as: 'functions_delete_week'
    end
    resources :shows do
      collection do 
        get 'billboard'
        get 'comingsoon'
      end 
      resources :comments, only: :index
      resources :images
      resources :functions
      resources :videos
      post 'functions/copy_last_day' => 'functions#copy_last_day', as: 'functions_copy'
    end
    post 'show_person_roles/sort' => 'show_person_roles#sort', as: 'show_person_roles_sort'
    
    resources :settings, only: [:index, :edit, :update]
  end
  
  match '*unmatched_route', :to => 'application#raise_route_not_found!'
end
