class EventTypeAsEnum < ActiveRecord::Migration
  def change
    add_column :events, :event_type, :integer, after: :name, default: 0
  end
end
