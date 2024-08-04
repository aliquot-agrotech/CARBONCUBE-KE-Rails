class CreatePurchasers < ActiveRecord::Migration[7.1]
  def change
    create_table :purchasers do |t|
      t.string :fullname
      t.string :username
      t.string :password_digest
      t.string :email
      t.string :phone_number
      t.string :location
      t.boolean :blocked, default: false

      t.timestamps
    end
    add_index :purchasers, :username
    add_index :purchasers, :email
  end
end
