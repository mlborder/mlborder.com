class CreateEventFinalBorders < ActiveRecord::Migration
  def change
    create_table :event_final_borders do |t|
      t.integer :event_id
      t.integer :rank, null: false, default: 1200
      t.integer :point, null: false

      t.timestamps null: false
    end
  end
end
