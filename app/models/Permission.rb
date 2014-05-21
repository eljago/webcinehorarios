# encoding: utf-8
class Permission
  
  def initialize(member)
    allow 'api/v1/shows', [:billboard, :show, :comingsoon]
    allow 'api/v1/cities', :index
    allow 'api/v1/theaters', :show_theaters_joins
    allow 'api/v1/cinemas', [:show]
    allow 'api/v1/functions', [:index, :show_functions]

    allow 'api/v2/shows', [:billboard, :show, :comingsoon]
    allow 'api/v2/theaters', [:index, :show_theaters, :favorite_theaters, :theater_coordinates]
    allow 'api/v2/functions', [:index, :show_functions]
    allow 'api/v2/videos', [:index]

    allow 'api/v3/shows', [:billboard, :show, :comingsoon]
    allow 'api/v3/theaters', [:show_theaters, :favorite_theaters, :theater_coordinates, :show]
    allow 'api/v3/functions', []
    allow 'api/v3/videos', [:index]
    allow 'api/v3/cinemas', [:show]
    allow 'api/v3/awards', [:index]
    
    allow 'api/v4/shows', [:billboard, :show, :comingsoon]
    allow 'api/v4/theaters', [:show_theaters, :favorite_theaters, :theater_coordinates, :show]
    allow 'api/v4/functions', []
    allow 'api/v4/videos', [:index]
    allow 'api/v4/cinemas', [:show]
    allow 'api/v4/awards', [:index]
    
    allow :home, [:index]
    allow 'admin/contact_tickets', [:create]
    
    # devise 
    allow 'devise/sessions', [:new, :create, :destroy]
    # allow 'devise/passwords', [:create, :new, :edit, :update]
    # allow 'devise/registrations', [:cancel, :create, :new, :edit, :update, :destroy]
    allow 'api/v3/sessions', [:create, :destroy]
    allow 'api/v3/registrations', [:create]

    allow 'admin/dashboard', [:index]
    
    if member
      
      allow_all if member.admin?
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