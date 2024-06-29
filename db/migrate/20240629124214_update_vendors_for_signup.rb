class UpdateVendorsForSignup < ActiveRecord::Migration[7.1]
  def change
    remove_column :vendors, :purchaser_id, :uuid
    add_column :vendors, :enterprise_name, :string
  end
end
