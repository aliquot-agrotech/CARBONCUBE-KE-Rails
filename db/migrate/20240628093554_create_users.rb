class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_hash
      t.string :email
      t.string :phone_number
      t.date :birth_date
      t.string :location
      t.string :role

      t.timestamps
    end
    add_index :users, :username
    add_index :users, :email
  end
end
