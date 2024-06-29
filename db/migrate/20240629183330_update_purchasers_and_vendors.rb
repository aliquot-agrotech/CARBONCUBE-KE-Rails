class UpdatePurchasersAndVendors < ActiveRecord::Migration[7.1]
  def change
    # Remove password_hash from purchasers
    remove_column :purchasers, :password_hash, :string

    # Add email to vendors
    add_column :vendors, :email, :string
  end
end

