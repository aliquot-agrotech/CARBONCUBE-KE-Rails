class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :product, null: false, foreign_key: true
      t.references :vendor, null: false, foreign_key: true
      t.text :options, array: true, default: []
      t.text :notes

      t.timestamps
    end
  end
end
