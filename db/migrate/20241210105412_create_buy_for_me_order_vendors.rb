class CreateBuyForMeOrderVendors < ActiveRecord::Migration[7.1]
  def change
    create_table :buy_for_me_order_vendors do |t|
      t.references :buy_for_me_order, null: false, foreign_key: true
      t.references :vendor, null: false, foreign_key: true

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
