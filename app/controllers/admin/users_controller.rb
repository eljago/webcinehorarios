class Admin::UsersController < ApplicationController
  before_filter :check_user
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      #session[:user_id] = @user.id
      redirect_to [:admin, :users], notice: 'Usuario Creado con exito!'
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if current_user.admin?
      @user.attributes = params[:user]
      if @user.save(validate: false)
        redirect_to admin_users_path, notice: "Usuario Actualizado."
      else
        render "new"
      end
    else
      if @user.update_attributes(params[:user])
        redirect_to admin_cines_path, notice: "Usuario Actualizado."
      else
        render "new"
      end
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to [:admin, :users]
  end
  
  private
  
  def check_user
    if !current_user.admin? && current_user.id != User.find(params[:id]).id
      redirect_to admin_cines_path, notice: 'No puede editar a otros usuarios'
    end
  end
end
