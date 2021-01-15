class Income < ApplicationRecord
  self.primary_key = 'moneyforward_id'

  # has_one :large_category
  # has_one :medium_category

  scope :calculating_target, -> { where(calculating_target_flag: true) }

  class << self
    def import!(file, period_id)
      CSV.foreach(file.path, headers: true, encoding: 'Windows-31J:UTF-8') do |row|
        next if row['金額（円）'].to_i.negative?

        expense = find_by(moneyforward_id: row['ID'])
        expense.delete if expense.present?

        params = {}
        columns.each do |column|
          if %w[large_category_id medium_category_id].include?(column.name)
            category = Category.find_or_initialize_by(name: row[column.comment])
            next params[column.name] = category.id if category.id.present?

            category.size = 2 if column.name == 'medium_category_id'
            category.type = 2
            category.save
            next params[column.name] = category.id
          end
          params[column.name] = row[column.comment]
        end

        create(params.merge(period_id: period_id))
      end
    end
  end
end
