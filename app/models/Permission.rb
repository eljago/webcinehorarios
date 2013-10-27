class Permission
  
  def initialize(user, theater_id = 0)
    allow 'api/v1/shows', [:billboard, :show, :comingsoon]
    allow 'api/v1/cities', :index
    allow 'api/v1/theaters', :show_theaters_joins
    allow 'api/v1/cinemas', [:show]
    allow 'api/v1/functions', [:index, :show_functions]

    allow 'api/v2/shows', [:billboard, :show, :comingsoon]
    allow 'api/v2/theaters', [:index, :show_theaters, :favorite_theaters]
    allow 'api/v2/functions', [:index, :show_functions]
    
    allow :home, [:index]
    allow :cine, [:salaestrella]
    allow 'admin/sessions', [:new, :create, :destroy, :facebook_create]
    allow 'admin/contact_tickets', [:create]
        
    if user
      allow 'admin/cines', [:index]
      allow 'admin/functions', [:index, :new, :edit, :copy_last_day, :create, :destroy, :show] if user.theaters.map(&:id).include?(theater_id)
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