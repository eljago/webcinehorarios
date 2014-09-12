# == Schema Information
#
# Table name: opinions
#
#  id      :integer          not null, primary key
#  author  :string(255)
#  comment :text
#  date    :date
#

class Opinion < ActiveRecord::Base
  # attr_accessible :author, :comment, :date
end
