class AddRestrictionToEvents < ActiveRecord::Migration
  def up
    change_column :events, :name, :string, null: false
    change_column :events, :series_name, :string, null: true, unique: true, default: nil
    change_column :events, :started_at, :datetime, null: false
    change_column :events, :ended_at, :datetime, null: false
  end

  def down
    change_column :events, :name, :string, null: true
    change_column :events, :series_name, :string, null: true, unique: false
    change_column :events, :started_at, :datetime, null: true
    change_column :events, :ended_at, :datetime, null: true
  end
end
