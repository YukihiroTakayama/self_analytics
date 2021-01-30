class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.boolean :notified_flag, null: false, default: false
      t.text    :message, null: false, default: ''

      t.timestamps
    end
  end
end
