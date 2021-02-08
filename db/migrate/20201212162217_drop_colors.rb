class DropColors < ActiveRecord::Migration[6.0]
  def change
    drop_table    :colors
    rename_column :categories, :color_id, :color
    change_column :categories, :color,    :string
  end
end
