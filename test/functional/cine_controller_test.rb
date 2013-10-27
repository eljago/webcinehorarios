require 'test_helper'

class CineControllerTest < ActionController::TestCase
  test "should get salaestrella" do
    get :salaestrella
    assert_response :success
  end

end
