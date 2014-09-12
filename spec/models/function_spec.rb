
# == Schema Information
#
# Table name: functions
#
#  id         :integer          not null, primary key
#  theater_id :integer
#  show_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  date       :date
#
# Indexes
#
#  index_functions_on_show_id     (show_id)
#  index_functions_on_theater_id  (theater_id)
#
