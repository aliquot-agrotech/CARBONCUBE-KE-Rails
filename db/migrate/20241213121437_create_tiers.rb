class CreateTiers < ActiveRecord::Migration[7.0]
  def change
    create_table :tiers do |t|
      t.string :name, null: false
      t.integer :ads_limit, null: false
      t.timestamps
    end
  end
end
