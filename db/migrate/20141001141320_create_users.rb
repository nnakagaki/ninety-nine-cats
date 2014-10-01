class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name, index: true, null: false
      t.string :password_digest, null: false
      t.string :session_token, index: true, unique: true

      t.timestamps
    end
  end
end
