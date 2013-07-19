class Admin::SessionsController < ApplicationController

  def new
    
  end
  
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      if Rails.env.production?
        redirect_to "/auth/facebook"
      else
        session[:user_id] = user.id
        redirect_to admin_path
      end
    else
      flash.now.alert = 'Email or password is invalid'
      render 'new'
    end
  end
  
  def facebook_create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to admin_url
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to admin_path, notice: 'Logged out'
  end
end
