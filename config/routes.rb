require 'api_constraints'

Rails.application.routes.draw do

  devise_for :members

  root :to => 'home#index'

  namespace :graph, defaults: { format: 'json' }  do
  	scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true)  do
			resources :queries, via: [:post, :options]
	  end
	end

  ##### API #####
  namespace :api, defaults: { format: 'json' } do

    ##### V1 #####
    scope module: :v1, constraints: ApiConstraints.new(version: 1) do
      resources :theaters, only: [:create, :update, :destroy]
      resources :cinemas, only: [] do
        resources :theaters, only: :index
      end
      resources :shows, only: [:index, :destroy, :update, :create] do
        collection do
          get 'select_shows'
          get 'billboard'
          get 'comingsoon'
        end
      end
      resources :people, only: [:index, :destroy, :update, :create] do
        collection do
          get 'select_people'
        end
      end
      resources :videos, only: []
      resources :parsed_shows, only: [:index, :update, :destroy] do
        collection do
          get 'orphan'
        end
      end
    end

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

  end

  # ADMIN
  namespace :admin do

    get '' => 'dashboard#index', as: '/'

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
          post 'delete_week', as: 'functions_delete_week'
          post 'delete_day', as: 'functions_delete_day'
          post 'copy_last_day', as: 'functions_copy'
        end
      end
    end
    resources :shows, only: [:index, :edit, :new]
    resources :parsed_shows, only: [:index]

    # For Sorting Actors
    post 'show_person_roles/sort' => 'show_person_roles#sort', as: 'show_person_roles_sort'

    post 'destroy_all_parsed_shows' => 'functions#destroy_all_parsed_shows'
    post 'create_parsed_shows' => 'functions#create_parsed_shows'

    resources :settings, only: [:index, :edit, :update]
  end

	if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graph/queries"
    mount RailsDb::Engine => '/rails/db', :as => 'rails_db'
  end

  get '*unmatched_route', :to => 'application#raise_route_not_found!'
end
