class CreateBudgets < ActiveRecord::Migration[6.1]
  def change
    create_table :budgets do |t|
      t.integer :category_id
      t.integer :price, null: false, default: 0
      t.integer :period_id
      t.decimal :warning_percent, precision: 3, scale: 1, null: false, default: 0.0

      t.timestamps
    end
  end
end
