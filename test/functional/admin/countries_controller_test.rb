require 'test_helper'

class Admin::CountriesControllerTest < ActionController::TestCase
  setup do
    @country = countries(:one)
    session[:user_id] = users(:one).id
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:countries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create country" do
    assert_difference('Country.count') do
      post :create, country: { name: @country.name }
    end

    assert_redirected_to admin_countries_path
  end
  test "should not save country without name" do
    country = Country.new
    assert !country.save, "Saved the country without a name"
  end

  test "should get edit" do
    get :edit, id: @country
    assert_response :success
  end

  test "should update country" do
    put :update, id: @country, country: { name: @country.name }
    assert_redirected_to admin_countries_path
  end

  test "should destroy country" do
    assert_difference('Country.count', -1) do
      delete :destroy, id: @country
    end

    assert_redirected_to admin_countries_path
  end
end
