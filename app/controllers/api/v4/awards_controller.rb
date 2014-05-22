class Api::V4::AwardsController < Api::V4::ApiController
  
  def index
    @awards = Award.includes(award_specific_categories: [nominations: :nomination_person_roles]).order('awards.date DESC').where(active: true).all
  end
  
end