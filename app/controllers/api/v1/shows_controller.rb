module Api
  module V1
    class ShowsController < Api::V1::ApiController
      
      def billboard
        date = Date.current
        @shows = Show.joins(:functions).where(active: true, functions: {date: date}).includes(:genres)
        .select('shows.id, shows.name, shows.duration, shows.name_original, shows.image, shows.debut')
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
        shows.name_original, shows.information, shows.debut, shows.rating, shows.year, shows.facebook_id')
        .includes(:show_person_roles => :person).find(params[:id])
      end
      
    end
  end
end