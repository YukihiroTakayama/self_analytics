json.set! :categories do
  json.array! @categories do |category|
    json.id category.id
    json.name category.name
    json.color category.color
    json.dialog false
    json.expense_price category.expenses.calculating_target.where(period_id: @period_id).total_price || 0
    json.budget category.budget_price || 0
    json.use_rate category.budget&.use_rate || 0
    json.pie_chart_data category.pie_chart_data
    json.warning_percent category.budget_warning_percent || 0
  end
end
