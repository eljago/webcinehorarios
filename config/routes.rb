require 'api_constraints'

Webcinehorarios::Application.routes.draw do
  
  root :to => 'home#index'
  get "cines/salaestrella"
  
  mount Sidekiq::Web, at: "/sidekiq"

  ##### API #####
  namespace :api, defaults: { format: 'json' } do
    
    ##### V3 #####
    scope module: :v3, constraints: ApiConstraints.new(version: 3) do
      
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
    
    resources :cines, only: :index
    
    resources :opinions

    resources :cinemas, except: :show do
      resources :theaters
    end
    
    get '' => 'dashboard#index', as: '/'
    resources :contact_tickets, only: [:index, :show, :create]
    resources :users, :genres, :people
    resources :sessions
    
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
  end

end
