# == Schema Information
#
# Table name: cinemas
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  image       :string(255)
#  information :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string(255)
#  image_tmp   :string(255)
#
# Indexes
#
#  index_cinemas_on_slug  (slug) UNIQUE
#

require 'spec_helper'

describe Cinema do
  
  before { @cinema = Cinema.new(name: "Cinema Name", information: "Cinema Information") }
  
  subject { @cinema }

  it { should respond_to(:name) }
  it { should respond_to(:information) }
  it { should respond_to(:image) }
  it { should respond_to(:information) }
  it { should respond_to(:remote_image_url) }
  it { should respond_to(:theater_ids) }
  
  it { Cinema.reflect_on_association(:theaters).macro.should  eq(:has_many) }
  it { Cinema.reflect_on_association(:function_types).macro.should eq(:has_and_belongs_to_many) }
  it { Cinema.reflect_on_association(:parse_detector_types).macro.should   eq(:has_many) }
  
  it { should be_valid }
  
  describe "when name is not present" do
    before { @cinema.name = " " }
    it { should_not be_valid }
  end
end
