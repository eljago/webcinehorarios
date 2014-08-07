# == Schema Information
#
# Table name: nominations
#
#  id                         :integer          not null, primary key
#  winner                     :boolean
#  award_specific_category_id :integer
#  show_id                    :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

require 'test_helper'

class NominationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
