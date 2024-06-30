class RenameNameToFullnameInVendors < ActiveRecord::Migration[7.1]
  def change
    rename_column :vendors, :name, :fullname
  end
end
