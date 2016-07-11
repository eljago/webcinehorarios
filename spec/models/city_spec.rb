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
