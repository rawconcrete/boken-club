require "test_helper"

class TravelPlansControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get travel_plans_new_url
    assert_response :success
  end

  test "should get create" do
    get travel_plans_create_url
    assert_response :success
  end

  test "should get show" do
    get travel_plans_show_url
    assert_response :success
  end
end
