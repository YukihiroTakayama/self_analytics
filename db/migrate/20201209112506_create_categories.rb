class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string  :name
      t.integer :color_id
      t.integer :size, default: 3, null: false
      t.integer :type, default: 1, null: false

      t.timestamps
    end
  end
end
