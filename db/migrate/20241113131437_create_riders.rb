class CreateRiders < ActiveRecord::Migration[7.1]
  def change
    create_table :riders do |t|
      t.string :full_name
      t.string :phone_number
      t.date :date_of_birth
      t.string :email
      t.string :id_number
      t.string :driving_license
      t.string :vehicle_type
      t.string :license_plate
      t.string :physical_address
      t.string :password_digest
      t.string :next_of_kin_full_name
      t.string :relationship
      t.string :emergency_contact_phone_number

      t.timestamps
    end
  end
end
