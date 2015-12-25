class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :provider, null: false
      t.string  :uid, null: false
      t.string  :screen_name, null: false
      t.string  :name, null: false
      t.integer :roll, default: 0, null: false

      t.timestamps null: false
    end
  end
end
