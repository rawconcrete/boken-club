class Skill < ApplicationRecord
  has_many :adventure_skills, dependent: :destroy
  has_many :adventures, through: :adventure_skills

  has_many :location_skills, dependent: :destroy
  has_many :locations, through: :location_skills

  validates :name, presence: true
  validates :details, presence: true

  # scope for searching skills
  scope :search_by_name, ->(query) { where("name ILIKE ?", "%#{query}%") }

  # scope to find skills recommended for specific adventures and locations
  scope :recommended_for, ->(location_ids: nil, adventure_ids: nil) {
    skills = none

    # find skills related to adventures
    if adventure_ids.present?
      adventure_skills = joins(:adventure_skills)
        .where(adventure_skills: { adventure_id: adventure_ids })
        .distinct
      skills = skills.or(adventure_skills) if adventure_skills.exists?
    end

    # find skills related to locations
    if location_ids.present?
      location_skills = joins(:location_skills)
        .where(location_skills: { location_id: location_ids })
        .distinct
      skills = skills.or(location_skills) if location_skills.exists?
    end

    skills.any? ? skills : all.limit(5) # fallback to some basic skills if none found
  }
end
