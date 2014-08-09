# encoding: utf-8
class Admin::SessionsController < ApplicationController

  def new
    
  end
  
  def create
    user = User.where(email: params[:email])
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
  
  def destroy
    session[:user_id] = nil
    redirect_to new_admin_session_path, notice: 'Logged out'
  end
end
