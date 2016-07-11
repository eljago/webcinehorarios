require 'spec_helper'

describe Theater do
  
  let(:cinema) { FactoryGirl.create(:cinema) }
  before { @theater = cinema.theaters.build(name: "Alto las Condes", information: "Avenida Kennedy 9001, local 3092, Las Condes - Santiago / Mall Alto Las Condes.", latitude: "-33,3901201000", longitude: "-70,5460327000", web_url: "http://www.cinemark.cl/theatres/alto-las-condes", active: true) }
  
  subject { @theater }

  it { should respond_to(:address) }
  it { should respond_to(:information) }
  it { should respond_to(:latitude) }
  it { should respond_to(:longitude) }
  it { should respond_to(:name) }
  it { should respond_to(:web_url) }
  it { should respond_to(:active) }
  it { should respond_to(:cinema_id) }
  its(:cinema) { should eq cinema }
  it { should respond_to(:city_id) }
  
  it { Theater.reflect_on_association(:city).macro.should  eq(:belongs_to) }
  it { Theater.reflect_on_association(:cinema).macro.should eq(:belongs_to) }
  
  it { should accept_nested_attributes_for(:functions) }
  
  it { should be_valid }
  
  describe "when name is not present" do
    before { @theater.name = " " }
    it { should_not be_valid }
  end
end
