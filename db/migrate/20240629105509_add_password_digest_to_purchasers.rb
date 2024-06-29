class AddPasswordDigestToPurchasers < ActiveRecord::Migration[7.1]
  def change
    add_column :purchasers, :password_digest, :string
  end
end
