class AddBlockedToVendors < ActiveRecord::Migration[7.1]
  def change
    add_column :vendors, :blocked, :boolean
  end
end
