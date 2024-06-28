class RenameUsersToPurchasers < ActiveRecord::Migration[7.1]
  def change
    rename_table :users, :purchasers
  end
end