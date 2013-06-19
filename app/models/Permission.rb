class Permission
  
  def initialize(user)
    allow 'api/v1/shows', [:billboard, :show, :premieres, :comingsoon]
    allow 'api/v1/cities', :index
    allow 'api/v1/comments', :create
    allow 'api/v1/theaters', :show_theaters_joins
    allow 'api/v1/cinemas', [:show, :show_cinemas]
    allow 'api/v1/functions', [:index, :show_functions]
    allow :home, [:index, :contact, :create_contact]
    allow 'admin/sessions', [:new, :create, :destroy, :facebook_create]
    allow 'admin/dashboard', :index
    if user
      allow 'admin/cities', [:new, :create, :edit, :update, :index, :show, :destroy]
      allow 'admin/countries', [:new, :create, :edit, :update, :index, :show, :destroy]
      allow 'admin/users', [:edit, :update]
      allow 'admin/pages', [:new, :create, :edit, :update, :index, :show, :destroy]
      allow 'admin/images', [:new, :create, :edit, :update, :index, :show, :destroy]
      allow 'admin/contact_tickets', [:new, :create, :edit, :update, :index, :show, :destroy]
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