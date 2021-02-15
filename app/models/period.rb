class Period < ApplicationRecord
  has_many :expenses
  has_many :incomes
  has_many :prediction_expenses

  scope :maximum_price, -> { includes(:incomes).maximum('incomes.price') }
  scope :minimum_price, -> { includes(:expenses).maximum('expenses.price') }
  scope :target_period, ->(date) { find_by('beginning_date < ? AND end_date > ?', date, date) }

  def total_expense
    expenses.calculating_target.sum(:price)
  end

  def total_income
    incomes.calculating_target.sum(:price)
  end

  def balance
    total_income - total_expense
  end

  def transaction_list(order = :asc, limit = nil)
    expenses = self.expenses.calculating_target.order(transaction_date: order.to_sym, created_at: order.to_sym).to_a
    incomes = self.incomes.calculating_target.order(transaction_date: order.to_sym, created_at: order.to_sym).to_a

    balance = expenses + incomes
    balance.sort_by! { |b| b.transaction_date }
    balance.reverse! if order.to_sym == :desc
    balance.take!(limit) if limit.present?
    balance
  end

  def self.next_month_initialize
    next_month = Date.new(last.year, last.month).since(1.month)
    new(year: next_month.year, month: next_month.month)
  end
end
