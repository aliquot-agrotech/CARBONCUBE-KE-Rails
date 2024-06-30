class AddPasswordDigestToVendors < ActiveRecord::Migration[7.1]
  def change
    add_column :vendors, :password_digest, :string
  end
end
