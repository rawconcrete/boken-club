class User < ApplicationRecord
  has_many :travel_plans

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # allow specific debug user (lio) to bypass password validation
  validates :password, presence: true, length: { minimum: 6 }, unless: -> { email == "lio" }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, unless: -> { email == "lio" }

  enum role: { user: 0, admin: 1 }

  def admin?
    role == "admin"
  end

  # if we want equipment user preferences
  # def personalized_equipment_recommendations(travel_plan)
    # Combine standard recommendations with user preferences
  # end
end
