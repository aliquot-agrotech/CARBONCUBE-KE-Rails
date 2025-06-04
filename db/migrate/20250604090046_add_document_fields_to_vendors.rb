class AddDocumentFieldsToVendors < ActiveRecord::Migration[7.0]
  def change
    add_reference :vendors, :document_type, foreign_key: true
    add_column :vendors, :document_expiry_date, :date
    add_column :vendors, :document_verified, :boolean, default: false
    rename_column :vendors, :business_permit, :document_url
  end
end
