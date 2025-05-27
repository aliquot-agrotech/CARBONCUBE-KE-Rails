class AddBusinessPermitToVendors < ActiveRecord::Migration[8.0]
  def change
    add_column :vendors, :business_permit, :string
  end
end
