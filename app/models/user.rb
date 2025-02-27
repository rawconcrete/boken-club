# app/models/user.rb
class User < ApplicationRecord
  has_many :travel_plans
  has_many :user_equipments, dependent: :destroy
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

  # check if user owns specific equipment
  def owns_equipment?(equipment_id)
    # convert to integer if string
    equipment_id = equipment_id.to_i if equipment_id.is_a?(String)
    equipment_ids.include?(equipment_id)
  end

  # get equipment needed for a travel plan that the user doesn't own
  def equipment_to_buy(travel_plan)
    travel_plan.equipment.where.not(id: equipment_ids)
  end

  # get equipment needed for a travel plan that the user already owns
  def equipment_to_pack(travel_plan)
    travel_plan.equipment.where(id: equipment_ids)
  end
end
