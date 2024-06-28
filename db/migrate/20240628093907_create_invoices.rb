class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.references :order, null: false, foreign_key: true
      t.datetime :invoice_date
      t.decimal :total_amount

      t.timestamps
    end
  end
end
