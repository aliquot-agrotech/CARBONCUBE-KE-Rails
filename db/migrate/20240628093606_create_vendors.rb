class CreateVendors < ActiveRecord::Migration[7.1]
  def change
    create_table :vendors do |t|
      t.string :fullname
      t.text :description
      t.text :contact_info
      t.string :phone_number
      t.string :location
      t.decimal :total_revenue
      t.integer :total_orders
      t.jsonb :customer_demographics
      t.jsonb :analytics
      t.string :business_registration_number
      t.string :enterprise_name
      t.string :email
      t.string :password_digest
      t.timestamps
    end
  end
end
