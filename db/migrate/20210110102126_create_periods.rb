class CreatePeriods < ActiveRecord::Migration[6.1]
  def change
    create_table :periods do |t|
      t.date :beginning_date
      t.date :end_date
      t.integer :year
      t.integer :month

      t.timestamps
    end

    add_column :expenses, :period_id, :integer
    add_column :incomes,  :period_id, :integer
  end
end
