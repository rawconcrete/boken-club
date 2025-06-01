# app/controllers/admin/admin_controller.rb
class Admin::AdminController < ApplicationController
  before_action :authenticate_user!  # This ensures the user is logged in
  before_action :authorize_admin!    # This ensures the user is an admin

  def dashboard
    @locations = Location.all
    @adventures = Adventure.all
  end

  private

  def authorize_admin!
    redirect_to root_path, alert: "Access denied" unless current_user.admin?
  end
end
