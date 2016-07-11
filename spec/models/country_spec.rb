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
