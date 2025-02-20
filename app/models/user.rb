class User < ApplicationRecord
  has_many :travel_plans
  # add for equipments
  has_many :user_equipments
  has_many :equipment, through: :user_equipments

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # allow specific debug user (lio) to bypass password validation
  validates :password, presence: true, length: { minimum: 6 }, unless: -> { email == "lio" }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, unless: -> { email == "lio" }

  enum role: { user: 0, admin: 1 }

  def admin?
    role == "admin"
  end
end
