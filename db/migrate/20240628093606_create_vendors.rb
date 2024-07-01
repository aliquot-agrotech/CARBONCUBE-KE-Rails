class CreateVendors < ActiveRecord::Migration[7.1]
  def change
    create_table :vendors do |t|
      t.string :name
      t.text :description
      t.text :contact_info
      t.string :phone_number
      t.date :birth_date
      t.string :location
      t.references :category, null: false, foreign_key: true
      t.decimal :total_revenue
      t.integer :total_orders
      t.jsonb :customer_demographics
      t.jsonb :analytics

      t.timestamps
    end
  end
end
