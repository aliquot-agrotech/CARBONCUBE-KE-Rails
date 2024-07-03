class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.references :vendor, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :media
      t.decimal :price
      t.integer :quantity
      t.string :brand
      t.string :manufacturer
      t.string :package_weight
      t.decimal :package_length
      t.decimal :package_width
      t.decimal :package_height
      t.timestamps
    end
  end
end
