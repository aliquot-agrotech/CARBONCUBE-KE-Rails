class ChangeDeletedAtToFlaggedInProducts < ActiveRecord::Migration[7.1]
  def change
    # Remove the `deleted_at` column
    remove_column :products, :deleted_at, :datetime

    # Add the `flagged` column
    add_column :products, :flagged, :boolean, default: false, null: false
  end
end
