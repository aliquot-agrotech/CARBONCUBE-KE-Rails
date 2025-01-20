class CreateIncomes < ActiveRecord::Migration[6.1]
  def change
    create_table :incomes do |t|
      t.string :range, null: false, unique: true
      t.timestamps
    end
  end
end
