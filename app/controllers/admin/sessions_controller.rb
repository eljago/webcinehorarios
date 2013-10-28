# encoding: utf-8
class Admin::SessionsController < ApplicationController

  def new
    
  end
  
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if user.admin?
        redirect_to admin_path
      elsif !user.theaters.blank?
        redirect_to admin_cines_path
      else
        redirect_to root_path, error: 'No tiene cines'
      end
    else
      flash.now.alert = 'Email o password inválido'
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
    redirect_to new_admin_session_path, notice: 'Logged out'
  end
end
