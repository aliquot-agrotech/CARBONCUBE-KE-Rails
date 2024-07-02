class CreateOrderVendors < ActiveRecord::Migration[7.1]
  def change
    create_table :order_vendors do |t|
      t.references :order, null: false, foreign_key: true
      t.references :vendor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
