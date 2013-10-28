# encoding: utf-8
class Permission
  
  def initialize(user)
    allow 'api/v1/shows', [:billboard, :show, :comingsoon]
    allow 'api/v1/cities', :index
    allow 'api/v1/theaters', :show_theaters_joins
    allow 'api/v1/cinemas', [:show]
    allow 'api/v1/functions', [:index, :show_functions]

    allow 'api/v2/shows', [:billboard, :show, :comingsoon]
    allow 'api/v2/theaters', [:index, :show_theaters, :favorite_theaters]
    allow 'api/v2/functions', [:index, :show_functions]
    
    allow :home, [:index]
    allow :cines, [:salaestrella]
    allow 'admin/sessions', [:new, :create, :destroy, :facebook_create]
    allow 'admin/contact_tickets', [:create]
    
    if user
      allow 'admin/users', [:edit, :update]
      allow 'admin/cines', [:index]
      allow 'admin/functions', [:index, :new, :edit, :update, :copy_last_day, :delete_day, :create, :destroy]
      
      allow_all if user.admin?
    end
  end
  
  def allow?(controller, action)
    @allow_all || @allowed_actions[[controller.to_s, action.to_s]]
  end
  
  def allow_all
    @allow_all = true
  end
  
  def allow(controllers, actions)
    @allowed_actions ||= {}
    Array(controllers).each do |controller|
      Array(actions).each do |action|
        @allowed_actions[[controller.to_s, action.to_s]] = true
      end
    end
  end
  
end