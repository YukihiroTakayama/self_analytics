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

  def transaction_list(order = :asc, limit = 5)
    expenses = self.expenses.order(transaction_date: order.to_sym).limit(limit).to_a
    incomes = self.incomes.order(transaction_date: order.to_sym).limit(limit).to_a

    balance = expenses + incomes
    balance.sort_by! { |b| b.transaction_date }
    balance.reverse! if order.to_sym == :desc
    balance.take(limit)
  end
end
