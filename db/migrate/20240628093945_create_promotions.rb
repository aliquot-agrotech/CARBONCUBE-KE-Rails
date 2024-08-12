class CreatePromotions < ActiveRecord::Migration[7.1]
  def change
    create_table :promotions do |t|
      t.references :vendor, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.decimal :discount_percentage
      t.string :coupon_code
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
