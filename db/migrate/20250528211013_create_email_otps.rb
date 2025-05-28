class CreateEmailOtps < ActiveRecord::Migration[8.0]
  def change
    create_table :email_otps do |t|
      t.string :email
      t.string :otp_code
      t.datetime :expires_at
      t.boolean :verified

      t.timestamps
    end
  end
end
