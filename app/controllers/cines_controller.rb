class CinesController < ApplicationController
  layout 'cines'
  
  def salaestrella
    @functions = Theater.find('sala-estrella').functions.includes(:show, :showtimes, :function_types)
    .select('function_types.name, shows.id, shows.name, shows.image, shows.debut, showtimes.time')
      .order('shows.debut DESC, shows.id, showtimes.time ASC')
      .where(functions: { date: Date.current } ).all
  end
end
