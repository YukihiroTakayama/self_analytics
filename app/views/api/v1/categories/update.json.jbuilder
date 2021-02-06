json.set! :category do
  json.id @category.id
  json.name @category.name
  json.color @category.color
  json.dialog false
  json.expense_price @category.expenses.period(Time.now.year, Time.now.month).total_price.to_i
  json.budget @category.budget_price.to_i
  json.use_rate @category.use_rate
  json.pie_chart_data @category.pie_chart_data
end
