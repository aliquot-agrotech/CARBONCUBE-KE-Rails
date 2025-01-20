class CreatePurchasers < ActiveRecord::Migration[7.1]
  def change
    create_table :purchasers do |t|
      t.string :fullname
      t.string :username
      t.string :password_digest
      t.string :email
      t.string :phone_number, limit: 10
      t.datetime :birthdate
      t.string :zipcode
      t.string :city
      t.string :gender, default: 'Male'
      t.string :location
      t.string :profile_picture
      t.boolean :blocked, default: false
      t.references :income, foreign_key: true, null: true
      t.references :employment, foreign_key: true, null: true
      t.references :education, foreign_key: true, null: true
      t.references :sector, foreign_key: true, null: true

      t.timestamps
    end
    add_index :purchasers, :username
    add_index :purchasers, :email
  end
end
