class Admin::DashboardController < ApplicationController
  
  def index
    days_count = params[:days].present? ? params[:days] : 8
    today = Date.current
    cinemas = Cinema.order(:id).includes(:theaters).order('theaters.name').uniq.map do |cinema|
      {
        "name" => cinema.name,
        "theaters" => cinema.theaters.map do |theater|
          hash = theater.functions.where('functions.date IN (?)', today...(today+days_count)).group(:date).count
          {
            "name" => theater.name,
            "slug" => theater.slug,
            "days" => days_count.times.map do |n|
              hash[today + n].present? ? hash[today + n] : 0
            end
          }
        end
      }
    end

    @title = 'Dashboard'
    @app_name = 'DashboardApp'
    @props = {cinemas: cinemas}
    @prerender = false
    render file: 'react/render'
  end

end
