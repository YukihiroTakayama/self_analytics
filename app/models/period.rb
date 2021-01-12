class Period < ApplicationRecord
  has_many :expenses
  has_many :incomes

  scope :maximum_price, -> { includes(:incomes).maximum('incomes.price') }
  scope :minimum_price, -> { includes(:expenses).maximum('expenses.price') }
end
