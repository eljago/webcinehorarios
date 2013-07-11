module Api
  module V2
    class ShowsController < Api::V2::ApiController
      
      def billboard
        date = Date.current
        date = (date..date.next_week(:wednesday)) unless date.wday == 3
        @shows = Show.joins(:functions).where(active: true, functions: {date: date}).includes(:genres)
        .select('shows.id, shows.name, shows.duration, shows.name_original, shows.image, shows.debut, shows.rating')
        .order("debut DESC").uniq.all
      end
      
      def comingsoon
        date = Date.current
        @shows = Show.where('(debut > ? OR debut IS ?) AND active = ?', date, nil, true)
        .select('shows.id, shows.name, shows.debut, shows.name_original, shows.image, shows.debut')
        .order("debut ASC").all
      end
      
      def detailed_billboard
        date = Date.current
        @shows = Show.joins(:functions).where(active: true, functions: {date: date}).includes(:genres, :images, :videos)
        .select('shows.id, shows.name, shows.image, shows.duration, 
          shows.name_original, shows.information, shows.debut, shows.rating, shows.year')
        .order("debut DESC").uniq.all
      end
      
    end
  end
end