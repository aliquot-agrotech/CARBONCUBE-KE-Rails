class UpdateProductsForVendorCrud < ActiveRecord::Migration[7.1]
  def change
    # Removing columns that are not needed
    remove_column :products, :name, :string
    remove_column :products, :image_url, :string
    remove_column :products, :specifications, :jsonb
    remove_column :products, :compatibility, :text
    remove_column :products, :stock, :integer

    # Adding the new columns
    add_column :products, :title, :string
    add_column :products, :media, :jsonb, default: []
    add_column :products, :quantity, :integer
    add_column :products, :brand, :string
    add_column :products, :manufacturer, :string
    add_column :products, :package_dimensions, :string
    add_column :products, :package_weight, :decimal
  end
end
