# db/migrate/XXXX_create_vendor_tiers.rb
class CreateVendorTiers < ActiveRecord::Migration[7.1]
  def change
    create_table :vendor_tiers do |t|
      t.references :vendor, null: false, foreign_key: true
      t.references :tier, null: false, foreign_key: true
      t.integer :duration_months, null: false

      t.timestamps
    end
  end
end
