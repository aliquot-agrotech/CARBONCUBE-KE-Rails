class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :purchaser, null: false, foreign_key: true
      t.string :status, default: 'processing'  # Default status is 'processing'
      t.decimal :total_amount
      t.string :mpesa_transaction_code

      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
