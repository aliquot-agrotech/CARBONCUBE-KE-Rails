class CreateWishLists < ActiveRecord::Migration[7.1]
  def change
    create_table :wish_lists do |t|
      t.references :purchaser, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
