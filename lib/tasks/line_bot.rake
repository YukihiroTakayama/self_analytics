namespace :line_bot do
  task push_line_message: :environment do
    require 'line-bot-api'

    message = {
      type: 'text',
      text: text
    }
    client = Line::Bot::Client.new do |config|
      config.channel_secret = Rails.application.credentials.line_bot_client[:line_channel_secret]
      config.channel_token = Rails.application.credentials.line_bot_client[:line_channel_token]
    end
    response = client.push_message(Rails.application.credentials.line_bot_client[:line_user_id], message)
  end
end
