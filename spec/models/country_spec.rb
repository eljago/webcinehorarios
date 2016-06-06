# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string(255)
#
# Indexes
#
#  index_countries_on_slug  (slug) UNIQUE
#

require 'spec_helper'

describe Country do
  
  before { @country = Country.new(name: "Chile") }
  
  subject { @country }

  it { should respond_to(:name) }
  
  it { should be_valid }
  
  describe "when name is not present" do
    before { @country.name = " " }
    it { should_not be_valid }
  end
end
