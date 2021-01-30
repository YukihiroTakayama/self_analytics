class Budget < ApplicationRecord
  belongs_to :category
  belongs_to :period

  after_initialize :add_period_id

  def add_period_id
    return if period_id.present?

    period_id = Period.target_period(Date.today).id
    self.period_id = period_id
  end

  def use_rate(year = Time.now.year, month = Time.now.month)
    return 0 if category.budget_price.zero?

    ((category.expenses.period(year, month).total_price || 0) / category.budget_price).floor(1)
  end
end
