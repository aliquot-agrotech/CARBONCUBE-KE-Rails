class RemoveCategoryIdFromVendors < ActiveRecord::Migration[7.1]
  def change
    remove_column :vendors, :category_id, :uuid
  end
end
