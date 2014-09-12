# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  image      :string(255)
#  country_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string(255)
#
# Indexes
#
#  index_cities_on_country_id  (country_id)
#  index_cities_on_slug        (slug) UNIQUE
#

require 'spec_helper'

describe City do
  
  let(:country) { FactoryGirl.create(:country) }
  before { @city = country.cities.build(name: "Santiago") }
  
  subject { @city }

  it { should respond_to(:name) }
  its(:country) { should eq country }
  
  it { should be_valid }
  
  describe "when name is not present" do
    before { @city.name = " " }
    it { should_not be_valid }
  end
end
