class AddBusinessRegistrationNumberToVendors < ActiveRecord::Migration[7.1]
  def change
    add_column :vendors, :business_registration_number, :string
  end
end
