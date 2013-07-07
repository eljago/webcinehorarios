class Admin::DashboardController < ApplicationController
  
  def index
    @cinemas = Cinema.includes(:theaters)
  end
end
