# == Schema Information
#
# Table name: shows
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  image                 :string(255)
#  information           :text
#  duration              :integer
#  name_original         :string(255)
#  rating                :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  debut                 :date
#  year                  :integer
#  active                :boolean
#  image_tmp             :string(255)
#  facebook_id           :string(255)
#  metacritic_url        :string(255)
#  metacritic_score      :integer
#  imdb_code             :string(255)
#  imdb_score            :integer
#  rotten_tomatoes_url   :string(255)
#  rotten_tomatoes_score :integer
#  slug                  :string(255)
#
# Indexes
#
#  index_shows_on_slug  (slug) UNIQUE
#

require 'spec_helper'

describe Show do
  
  let(:show) { FactoryGirl.create(:show) }
  
  subject { show }

  it { should respond_to(:active) }
  it { should respond_to(:year) }
  it { should respond_to(:debut) }
  it { should respond_to(:image) }
  it { should respond_to(:information) }
  it { should respond_to(:duration) }
  it { should respond_to(:name_original) }
  it { should respond_to(:metacritic_url) }
  it { should respond_to(:metacritic_score) }
  it { should respond_to(:imdb_code) }
  it { should respond_to(:imdb_score) }
  it { should respond_to(:rotten_tomatoes_url) }
  it { should respond_to(:rotten_tomatoes_score) }

  it { should respond_to(:genres) }
  
  it { should be_valid }
  
  describe "when name is not present" do
    before { show.name = " " }
    it { should_not be_valid }
  end
end
