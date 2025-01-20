class CreateEmployments < ActiveRecord::Migration[6.1]
  def change
    create_table :employments do |t|
      t.string :status, null: false, unique: true
      t.timestamps
    end
  end
end
