# == Schema Information
#
# Table name: theaters
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  image        :string(255)
#  address      :string(255)
#  information  :text
#  cinema_id    :integer
#  city_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  web_url      :string(255)
#  active       :boolean
#  slug         :string(255)
#  latitude     :decimal(15, 10)
#  longitude    :decimal(15, 10)
#  parse_helper :string(255)
#
# Indexes
#
#  index_theaters_on_city_id_and_cinema_id  (city_id,cinema_id)
#  index_theaters_on_slug                   (slug) UNIQUE
#

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
