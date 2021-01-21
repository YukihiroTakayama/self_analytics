namespace :line_bot do
  task push_line_message: :environment do
    require 'line-bot-api'

    current_year = Time.now.year
    current_month = Time.now.month
    expenses = Period.find_by(year: current_year, month: current_month).expenses.calculating_target

    aggregate_expenses = expenses.group(:large_category_id).sum(:price)

    text = ''
    categories = Category.where(id: aggregate_expenses.keys).pluck(:id, :name).to_h
    aggregate_expenses.each do |key, value|
      text += "#{categories[key]}: #{value}円\n"
    end

    text += "合計: #{expenses.sum(:price)}円"

    message = {
      type: 'text',
      text: text
    }
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"] || 'cc02e93034a0019a0b4850b688122d81'
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"] || 'Aa5202kUrOjTWmvkEseRgHwnaZk93kZSvhMJTiUgabnbfCUPUerkmEih0wzLnc9sDpuzHSWnjm4Iy98B4Ki9gpvbyHOYDrcccD/ozKEu5weXLFLbva3kNuVSOwxTI5OUwUyaU8Dvk6iwEGYB3+U/rAdB04t89/1O/w1cDnyilFU='
    }
    response = client.push_message(ENV["LINE_USER_ID"] || 'Uab2824ccb18f39401a58c28fd317f1e6', message)
  end
end
