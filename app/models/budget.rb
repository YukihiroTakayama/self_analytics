class Budget < ApplicationRecord
  belongs_to :category

  def use_rate(year = Time.now.year, month = Time.now.month)
    return 0 if category.budget_price.zero?

    ((category.expenses.period(year, month).total_price || 0) / category.budget_price).floor(1)
  end
end
