
# == Schema Information
#
# Table name: show_person_roles
#
#  id         :integer          not null, primary key
#  person_id  :integer
#  show_id    :integer
#  actor      :boolean
#  writer     :boolean
#  creator    :boolean
#  producer   :boolean
#  director   :boolean
#  created_at :datetime
#  updated_at :datetime
#  character  :string(255)
#  position   :integer
#
# Indexes
#
#  index_show_person_roles_on_person_id_and_show_id  (person_id,show_id)
#
