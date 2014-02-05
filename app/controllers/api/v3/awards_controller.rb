module Api
  module V3
    class AwardsController < Api::V3::ApiController
      
      def index
        @awards = Award.includes(award_specific_categories: [nominations: :nomination_person_roles]).order('awards.date DESC').where(active: true).all
      end
      
    end
  end
end
