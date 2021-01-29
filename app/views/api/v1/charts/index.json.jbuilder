json.set! :line_chart do
  json.labels @labels
  json.datasets @datasets
end
json.set! :pie_chart_data, @pie_chart_data
json.set! :years, @years
json.set! :year, @target_period.year
json.set! :month, @target_period.month
json.set! :total_expense, @target_period.total_expense
json.set! :total_income, @target_period.total_income
json.set! :balance, @target_period.balance
json.set! :amount, @amount
json.set! :transaction_list do
  json.array! @target_period.transaction_list do |transaction|
    json.extract! transaction, :transaction_date, :content, :large_category_name, :price, :medium_category_name
  end
end
# json.set! :maximum_price, @periods.maximum_price.present? ? @periods.maximum_price : 0
# json.set! :minimum_price, @periods.minimum_price.present? ? @periods.minimum_price : 0
