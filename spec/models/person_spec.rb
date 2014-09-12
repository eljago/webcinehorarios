
# == Schema Information
#
# Table name: people
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  image      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  image_tmp  :string(255)
#  slug       :string(255)
#  imdb_code  :string(255)
#
# Indexes
#
#  index_people_on_slug  (slug) UNIQUE
#
