json.set! :categories do
  json.array! @categories do |category|
    json.id category.id
    json.name category.name
    json.color category.color
    json.dialog false
  end
end