json.set! :fixed_expenses do
  json.array! @fixed_expenses do |fixed_expense|
    json.id fixed_expense.id
    json.content fixed_expense.content
    json.price fixed_expense.price
    json.dialog false
    json.large_category fixed_expense.large_category
  end
end
json.set! :total_price, @fixed_expenses.total_price
