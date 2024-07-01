class AddPackageDimensionsToProducts < ActiveRecord::Migration[7.1]
  def change
    # Remove the combined package_dimensions column if it was already added
    remove_column :products, :package_dimensions, :string if column_exists?(:products, :package_dimensions)

    # Add individual package dimensions columns
    add_column :products, :package_length, :decimal
    add_column :products, :package_width, :decimal
    add_column :products, :package_height, :decimal
  end
end
