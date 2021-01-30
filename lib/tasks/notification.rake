namespace :nitification do
  task reservation: :environment do
    Category.budget_price_excess_categories.each do |category|
      text = "#{category.name}: 支出が予算超過しています。"
      Notification.create(message: text)
    end
    Category.budget_warning_percent_excess_categories.each do |category|
      text = "#{category.name}: 支出が警告値を超えました。"
      Notification.create(message: text)
    end
  end

  task push_line_message: :environment do
    require 'line-bot-api'

    client = Line::Bot::Client.new do |config|
      config.channel_secret = Rails.application.credentials.line_bot_client[:line_channel_secret]
      config.channel_token = Rails.application.credentials.line_bot_client[:line_channel_token]
    end
    Notification.notified.each do |notification|
      message = {
        type: 'text',
        text: notification.message
      }
      response = client.push_message(Rails.application.credentials.line_bot_client[:line_user_id], message)
      next if response.code != '200'

      notification.update(notified_flag: true)
    end
  end
end
