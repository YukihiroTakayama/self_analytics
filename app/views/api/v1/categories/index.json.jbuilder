json.set! :categories do
  json.array! @categories do |category|
    json.id category.id
    json.name category.name
    json.color category.color
    json.dialog false
    json.expense_price category.expenses.period(Time.now.year, Time.now.month).total_price || 0
    json.budget category.budget_price || 0
    json.use_rate category.budget&.use_rate || 0
    json.pie_chart_data category.pie_chart_data
  end
end
