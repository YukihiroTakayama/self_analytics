json.set! :line_chart do
  json.labels @labels
  json.datasets @datasets
end
json.set! :years, @years
json.set! :year, params[:year]
json.set! :month, params[:month]
json.set! :total_expense, @target_period.total_expense
json.set! :total_income, @target_period.total_income
json.set! :balance, @target_period.balance
# json.set! :maximum_price, @periods.maximum_price.present? ? @periods.maximum_price : 0
# json.set! :minimum_price, @periods.minimum_price.present? ? @periods.minimum_price : 0
