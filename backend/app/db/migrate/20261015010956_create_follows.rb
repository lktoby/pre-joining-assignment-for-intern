class CreateFollows < ActiveRecord::Migration[8.1]
  def change
    create_table :follows do |t|
      t.references :user, null: false, foreign_key: { to_table: :users, on_delete: :cascade }
      t.references :target_user, null: false, foreign_key: { to_table: :users, on_delete: :cascade }

      t.timestamps
    end
    add_index :follows, [:user_id, :target_user_id], unique: true
  end
end
