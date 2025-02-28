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
    result = none

    # find skills related to adventures
    if adventure_ids.present?
      adventure_skill_ids = AdventureSkill
        .where(adventure_id: adventure_ids)
        .pluck(:skill_id)

      if adventure_skill_ids.any?
        result = where(id: adventure_skill_ids)
      end
    end

    # find skills related to locations
    if location_ids.present?
      location_skill_ids = LocationSkill
        .where(location_id: location_ids)
        .pluck(:skill_id)

      if location_skill_ids.any?
        if result.any?
          # combine with existing results
          result = result.or(where(id: location_skill_ids))
        else
          result = where(id: location_skill_ids)
        end
      end
    end

    # return result or fallback to some basic skills
    result.any? ? result : all.limit(5)
  }
end
