# == Schema Information
#
# Table name: show_debuts
#
#  id         :integer          not null, primary key
#  show_id    :integer
#  debut      :date
#  created_at :datetime
#
# Indexes
#
#  index_show_debuts_on_show_id  (show_id)
#

require 'spec_helper'

describe ShowDebut do
  pending "add some examples to (or delete) #{__FILE__}"
end
