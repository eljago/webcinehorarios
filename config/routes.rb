require 'api_constraints'

Webcinehorarios::Application.routes.draw do
  
  root :to => 'home#index'
  
  mount Resque::Server, :at => "/resque"
  
  match 'auth/:provider/callback', to: 'admin/sessions#facebook_create'
  match 'auth/failure', to: redirect('/admin')

  ##### API #####
  namespace :api, defaults: { format: 'json' } do
    
    ##### V2 #####
    scope module: :v2, constraints: ApiConstraints.new(version: 2) do
      resources :cinemas, only: [:show]

      get 'billboard' => 'shows#billboard'
      get 'detailed_billboard' => 'shows#detailed_billboard'
      get 'premieres' => 'shows#premieres'
      get 'comingsoon' => 'shows#comingsoon'
      
      resources :shows, only: [] do
        resources :comments, only: :create
        get 'show_cinemas' => 'cinemas#show_cinemas'
        get 'show_functions' => 'functions#show_functions'
        get 'show_cinemas_joins' => 'cinemas#show_cinemas_joins'
        get 'show_theaters_joins' => 'theaters#show_theaters_joins'
      end
      
      resources :countries, only: [] do
        resources :cities, only: :index
      end
      
      resources :theaters, only: [] do
        resources :functions, only: :index
      end
    end
    
    ##### V1 ######
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :cinemas, only: [:show]

      get 'billboard' => 'shows#billboard'
      get 'premieres' => 'shows#premieres'
      get 'comingsoon' => 'shows#comingsoon'
      
      resources :shows, only: :show do
        resources :comments, only: :create
        get 'show_cinemas' => 'cinemas#show_cinemas'
        get 'show_functions' => 'functions#show_functions'
        get 'show_cinemas_joins' => 'cinemas#show_cinemas_joins'
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
    
    resources :opinions

    resources :cinemas, except: :show do
      resources :theaters
    end
    
    get '' => 'dashboard#index', as: '/'
    resources :contact_tickets, only: [:index, :show, :create]
    resources :users, :sessions, :genres, :function_types, :people
    resources :pages do
      resources :images
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
      post 'functions/copy_last_day' => 'functions#copy_last_day', as: 'functions_copy'
      post 'functions/delete_day' => 'functions#delete_day', as: 'functions_delete_day'
    end
    resources :shows do
      resources :comments, only: :index
      resources :images
      resources :functions
      resources :videos
      post 'functions/copy_last_day' => 'functions#copy_last_day', as: 'functions_copy'
      match 'create_facebook' => 'shows#create_facebook'
    end
  end

end
