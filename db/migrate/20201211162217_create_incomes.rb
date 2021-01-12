class CreateIncomes < ActiveRecord::Migration[6.0]
  def change
    create_table :incomes do |t|
      t.boolean :calculating_target_flag,     comment: '計算対象'
      t.date    :income_date,                 comment: '日付'
      t.string  :content,                     comment: '内容'
      t.integer :price,                       comment: '金額（円）'
      t.integer :owned_financial_facility,    comment: '保有金融機関'
      t.integer :large_category_id,           comment: '大項目'
      t.integer :medium_category_id,          comment: '中項目'
      t.string  :memo,                        comment: 'メモ'
      t.boolean :transfer_flag,               comment: '振替'
      t.string  :moneyforward_id,             comment: 'ID'

      t.timestamps
    end
  end
end
