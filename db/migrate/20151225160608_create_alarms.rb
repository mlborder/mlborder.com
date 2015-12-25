class CreateAlarms < ActiveRecord::Migration
  def change
    create_table :alarms do |t|
      t.integer :event_id, null: false
      t.integer :user_id, null: false
      t.integer :status, null: false, default: 0
      t.integer :target, null: false
      t.integer :rank, null: false
      t.decimal :value, null: false

      t.timestamps null: false
    end
  end
end
