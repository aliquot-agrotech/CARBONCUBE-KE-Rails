class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :purchaser, null: false, foreign_key: true
      t.string :status
      t.decimal :total_amount
      t.boolean :is_sent_out
      t.boolean :is_processing
      t.boolean :is_delivered

      t.timestamps
    end
  end
end
