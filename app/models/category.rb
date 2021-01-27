class Category < ApplicationRecord
  self.inheritance_column = :_type_disabled

  has_many :expenses, foreign_key: 'large_category_id'
  has_many :incomes, foreign_key: 'large_category_id'
  has_one  :budget

  accepts_nested_attributes_for :budget, update_only: true

  enum size: { small: 1, medium: 2, large: 3 }
  enum type: { expense: 1, income: 2 }

  delegate :price, to: :budget, prefix: true, allow_nil: true

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
end
