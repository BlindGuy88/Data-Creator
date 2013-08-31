require 'test_helper'

class MainDummyProcessControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get code field view" do
    get :get_code_field
    assert_response :success
  end

  test "should get generate data view" do
    get :generate_data
    assert_response :success
  end


end
