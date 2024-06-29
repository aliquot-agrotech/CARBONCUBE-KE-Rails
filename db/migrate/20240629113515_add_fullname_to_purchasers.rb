class AddFullnameToPurchasers < ActiveRecord::Migration[7.1]
  def change
    add_column :purchasers, :fullname, :string
  end
end
