class AddUniqueIndexToVendorAndPurchaserEmails < ActiveRecord::Migration[8.0]
  def change
    remove_index :vendors, :email if index_exists?(:vendors, :email)
    remove_index :purchasers, :email if index_exists?(:purchasers, :email)

    add_index :vendors, 'LOWER(email)', unique: true, name: 'index_vendors_on_lower_email'
    add_index :purchasers, 'LOWER(email)', unique: true, name: 'index_purchasers_on_lower_email'
  end
end
