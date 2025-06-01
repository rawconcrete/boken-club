require "test_helper"

class UserEquipmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get user_equipments_create_url
    assert_response :success
  end
end
