class SessionsController < Devise::SessionsController
  skip_before_filter :require_no_authentication, :only => [:new]  

  def create
    if verify_recaptcha
      super
    else
      build_resource
      flash[:error] = "Captcha has wrong, try a again."
      respond_with_navigational(resource) { render :new }
    end    
  end
end