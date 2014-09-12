require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "Dashboards" do
  # Runs before each test.
  before do
    member = FactoryGirl.create(:member)
    login_as(member, :scope => :member)
  end
  
  after do
    Warden.test_reset!
  end
  
  describe "Index" do
    it "should have title Dashboard" do
      visit admin_path
      
      # save_and_open_page
      
      expect(page).to have_title('Dashboard')
    end
  end
end
