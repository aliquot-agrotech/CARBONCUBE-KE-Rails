class CreateCounties < ActiveRecord::Migration[7.0]
  def change
    create_table :counties do |t|
      t.string :name, null: false, unique: true
      t.string :capital, null: false
      t.integer :county_code, null: false, unique: true

      t.timestamps
    end
  end
end
