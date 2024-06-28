class UpdateUserAndVendorModels < ActiveRecord::Migration[7.1]
  def change
    # Removing birth date from users and vendors
    remove_column :users, :birth_date, :date
    remove_column :vendors, :birth_date, :date

    # Adding business number registration to vendors
    add_column :vendors, :business_number_registration, :string
  end
end