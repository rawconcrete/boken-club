# db/migrate/20250227125804_add_name_to_users.rb
class AddNameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :name, :string
  end
end
