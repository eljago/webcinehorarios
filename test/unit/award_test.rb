# == Schema Information
#
# Table name: awards
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  active        :boolean
#  date          :date
#  image         :string(255)
#  image_tmp     :string(255)
#  award_type_id :integer
#

require 'test_helper'

class AwardTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
