class CreateUserProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :user_profiles do |t|
      t.integer :user_id, null: false
      t.string :player_id
      t.integer :produce_idol_id
      t.text :description

      t.timestamps
    end
    add_index :user_profiles, :user_id, unique: true
    add_index :user_profiles, :produce_idol_id, unique: true
    add_foreign_key :user_profiles, :users, column: :user_id, on_delete: :cascade
  end
end
