class AddRecordsFlagToEvents < ActiveRecord::Migration
  def change
    add_column :events, :records_available, :boolean, after: :ended_at, null: false, default: false
  end
end
