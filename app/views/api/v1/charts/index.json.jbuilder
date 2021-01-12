json.set! :line_chart do
  json.labels @labels
  json.datasets @datasets
end
json.set! :months, @months
json.set! :years, @years
json.set! :maximum_price, @periods.maximum_price.present? ? @periods.maximum_price : 0
json.set! :minimum_price, @periods.minimum_price.present? ? @periods.minimum_price : 0
