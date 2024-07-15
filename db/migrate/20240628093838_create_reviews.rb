class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :product, null: false, foreign_key: true
      t.references :purchaser, null: false, foreign_key: true
      t.integer :rating, null: false, limit: 1
      t.text :review
      t.text :reply

      t.timestamps
    end
  end
end
