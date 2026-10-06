class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :body
      t.boolean :is_completed, default: false

      t.timestamps
    end
  end
end
