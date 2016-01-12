class CreateEventPrizes < ActiveRecord::Migration
  def change
    create_table :event_prizes do |t|
      t.references :event
      t.references :idol
      t.timestamps null: false
    end
  end
end
