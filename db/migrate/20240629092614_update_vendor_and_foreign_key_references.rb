class UpdateVendorAndForeignKeyReferences < ActiveRecord::Migration[7.1]
  def change
    # Remove product_inventory from vendors table
    remove_column :vendors, :product_inventory, :jsonb

    # Rename user_id to purchaser_id in reviews, orders, and vendors tables
    rename_column :reviews, :user_id, :purchaser_id
    rename_column :orders, :user_id, :purchaser_id
    rename_column :vendors, :user_id, :purchaser_id
  end
end