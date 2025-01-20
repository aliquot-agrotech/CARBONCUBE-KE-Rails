class CreateEducations < ActiveRecord::Migration[6.1]
  def change
    create_table :educations do |t|
      t.string :level, null: false, unique: true
      t.timestamps
    end
  end
end
