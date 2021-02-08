class Category < ApplicationRecord

  R_COLOR_RANGE = [*0..255]
  G_COLOR_RANGE = [*0..255]
  B_COLOR_RANGE = [*0..255]

  self.inheritance_column = :_type_disabled

  has_many :expenses, foreign_key: 'large_category_id'
  has_many :incomes, foreign_key: 'large_category_id'
  has_one  :budget

  accepts_nested_attributes_for :budget, update_only: true

  enum size: { small: 1, medium: 2, large: 3 }
  enum type: { expense: 1, income: 2 }

  delegate :price, to: :budget, prefix: true, allow_nil: true
  delegate :warning_percent, to: :budget, prefix: true, allow_nil: true

  after_initialize :random_color

  class << self
    def budget_price_excess_categories(target_date = Date.today)
      period_id = Period.target_period(target_date)&.id
      return [] if period_id.nil?

      target_expenses = Expense.calculating_target.where(period_id: period_id).group(:large_category_id).sum(:price)
      target_categories = large.includes(:budget).where(budgets: { period_id: period_id }).to_a
      target_categories.map! do |category|
        category if (category.budget_price || 0) < (target_expenses[category.id] || 0)
      end
      target_categories.compact
    end

    def budget_warning_percent_excess_categories(target_date = Date.today)
      period_id = Period.target_period(target_date)&.id
      return [] if period_id.nil?

      target_expenses = Expense.calculating_target.where(period_id: period_id).group(:large_category_id).sum(:price)
      target_categories = large.includes(:budget).where(budgets: { period_id: period_id }).to_a
      target_categories.map! do |category|
        next if category.budget_price.nil? || category.budget_price.zero?
        next if (category.budget_price || 0) < (target_expenses[category.id] || 0)

        current_percent = par(target_expenses[category.id] || 0) / (category.budget_price).floor(1)
        category if category.budget_warning_percent <= current_percent
      end
      target_categories.compact
    end
  end

  def pie_chart_data(year = Time.now.year, month = Time.now.month)
    period = Period.find_by(year: year, month: month)
    total_expense_price = period.expenses.where(large_category_id: id).sum(:price)
    medium_category_price_list = period.expenses.where(large_category_id: id).group(:medium_category_id).sum(:price)
    categories = Category.where(id: medium_category_price_list.keys)
    labels = categories.pluck(:name)
    colors = categories.pluck(:color)
    {
      datasets: [{
        data: medium_category_price_list.values,
        backgroundColor: colors
      }],
      labels: labels
    }
  end

  def use_rate(date = Date.today)
    return 0 if budget_price.to_i.zero?

    period_id = Period.target_period(date).id
    target_expenses = expenses.where(period_id: period_id)
    (target_expenses.total_price / budget_price.to_f).floor(2) * 100
  end

  def random_color
    return if self.color.present?

    r = R_COLOR_RANGE.sample
    g = G_COLOR_RANGE.sample
    b = B_COLOR_RANGE.sample
    self.color = "##{"%02x"%r}#{"%02x"%g}#{"%02x"%b}"
  end
end
