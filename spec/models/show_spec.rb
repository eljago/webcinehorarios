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
