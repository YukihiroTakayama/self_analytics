class CreateColors < ActiveRecord::Migration[6.0]
  def change
    create_table :colors do |t|
      t.string  :name
      t.integer :red
      t.integer :green
      t.integer :blue

      t.timestamps
    end
  end
end
