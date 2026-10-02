class CreateUserAuthentications < ActiveRecord::Migration[8.1]
  def change
    create_table :user_authentications, :id => false do |t|
      t.string :identifier, primary_key: true, null: false
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :password_digest

      t.timestamps
    end
  end
end
