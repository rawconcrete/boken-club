class AddIsRequiredToSkillAssociations < ActiveRecord::Migration[7.1]
  def change
    add_column :adventure_skills, :is_required, :boolean, default: false
    add_column :location_skills, :is_required, :boolean, default: false
  end
end
