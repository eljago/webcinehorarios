class Admin::CinesController < ApplicationController
  def index
    @theaters = current_user.theaters
  end
end
