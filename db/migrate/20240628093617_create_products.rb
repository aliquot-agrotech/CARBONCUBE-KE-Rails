class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.references :vendor, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.text :media
      t.decimal :price, precision: 10, scale: 2
      t.integer :quantity
      t.string :brand
      t.string :manufacturer
      t.decimal :package_weight, precision: 10, scale: 2
      t.decimal :package_length, precision: 10, scale: 2
      t.decimal :package_width, precision: 10, scale: 2
      t.decimal :package_height, precision: 10, scale: 2
      t.boolean :flagged, default: false 
      t.timestamps
    end
  end
end
