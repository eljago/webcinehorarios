class Api::V4::ShowsController < Api::V4::ApiController
  
  def billboard
    current_day = Date.current
    date = current_day + ((3-current_day.wday) % 7)
    @shows = Show.joins(:functions).where('shows.active = ? AND shows.debut <= ? AND functions.date = ?', true, date, current_day)
    .includes(:genres)
    .select('shows.id, shows.name, shows.duration, shows.name_original, shows.image, shows.debut, shows.rating')
    .order("debut DESC").uniq.all
  end
  
  def comingsoon
    date = Date.current
    @shows = Show.where('(debut > ? OR debut IS ?) AND active = ?', date, nil, true)
    .select('shows.id, shows.name, shows.debut, shows.name_original, shows.image, shows.debut')
    .order("debut ASC").all
  end
  
  def show
    @show = Show.select('shows.id, shows.name, shows.image, shows.duration,
    shows.name_original, shows.information, shows.debut, shows.rating, shows.year,
    shows.metacritic_score, shows.imdb_score, shows.rotten_tomatoes_score,
    shows.metacritic_url, shows.imdb_code, shows.rotten_tomatoes_url')
    .includes(:show_person_roles => :person).order('show_person_roles.position').find(params[:id])
  end
  
end