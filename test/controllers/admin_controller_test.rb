require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  before_action :authenticate_admin!

  def dashboard
    @locations = Location.all
    @adventures = Adventure.all
  end
end
