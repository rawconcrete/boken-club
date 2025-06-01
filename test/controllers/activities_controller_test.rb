require "test_helper"

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get activities_search_url
    assert_response :success
  end
end
