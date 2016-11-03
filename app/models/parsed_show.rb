class ParsedShow < ApplicationRecord
	
  belongs_to :show
  has_many :functions

  def show_name
    return (show.present? ? show.name : '')
  end
end
