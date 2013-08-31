require 'test_helper'

class Admin::CountryTest < ActiveSupport::TestCase

  test "should not save country without name" do
    country = Country.new
    assert !country.save, "Saved the country without a name"
  end

end
