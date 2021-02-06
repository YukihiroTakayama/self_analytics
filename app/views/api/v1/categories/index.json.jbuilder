json.set! :categories do
  json.array! @categories do |category|
    json.id category.id
    json.name category.name
    json.color category.color
    json.dialog false
    json.expense_price category.expenses.calculating_target.where(period_id: @period_id).total_price || 0
    json.budget category.budget_price || 0
    json.use_rate category.use_rate
    json.pie_chart_data category.pie_chart_data
    json.warning_percent category.budget_warning_percent.to_i
  end
end
