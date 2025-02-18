class Equipment < ApplicationRecord
  has_many :equipment_locations
  has_many :locations, through: :equipment_locations
  has_many :equipment_adventures
  has_many :adventures, through: :equipment_adventures
  has_many :user_equipments
  has_many :users, through: :user_equipments
  has_many :equipment_tips
  has_many :tips, through: :equipment_tips

  validates :name, presence: true
  validates :description, presence: true
end
