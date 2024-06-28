class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.references :vendor, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.string :image_url
      t.jsonb :specifications
      t.text :compatibility
      t.decimal :price
      t.integer :stock

      t.timestamps
    end
  end
end
