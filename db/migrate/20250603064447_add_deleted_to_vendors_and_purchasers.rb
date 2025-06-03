class AddDeletedToVendorsAndPurchasers < ActiveRecord::Migration[8.0]
  def change
    add_column :vendors, :deleted, :boolean, default: false, null: false
    add_column :purchasers, :deleted, :boolean, default: false, null: false
  end
end
