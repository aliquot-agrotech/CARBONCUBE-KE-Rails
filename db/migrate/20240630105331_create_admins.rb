class CreateAdmins < ActiveRecord::Migration[7.1]
  def change
    create_table :admins do |t|
      t.string :fullname
      t.string :username
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
