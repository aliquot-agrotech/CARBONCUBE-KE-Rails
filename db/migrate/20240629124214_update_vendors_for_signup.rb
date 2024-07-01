class UpdateVendorsForSignup < ActiveRecord::Migration[7.1]
  def change
    add_column :vendors, :enterprise_name, :string
  end
end
