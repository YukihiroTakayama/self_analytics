json.set! :prediction_expenses do
  json.array! @prediction_expenses do |prediction_expense|
    json.id prediction_expense.id
    json.content prediction_expense.content
    json.price prediction_expense.price
    json.dialog false
    json.large_category prediction_expense.large_category
  end
end
json.set! :total_price, @prediction_expenses.total_price
