class Period < ApplicationRecord
  has_many :expenses
  has_many :incomes

  scope :maximum_price, -> { includes(:incomes).maximum('incomes.price') }
  scope :minimum_price, -> { includes(:expenses).maximum('expenses.price') }

  def total_expense
    expenses.calculating_target.sum(:price)
  end

  def total_income
    incomes.calculating_target.sum(:price)
  end

  def balance
    total_income - total_expense
  end
end
