require File.expand_path(File.dirname(__FILE__) + "/environment")

rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env
set :output, "#{Rails.root}/log/cron.log"

if rails_env.to_sym == :production
  every 10.minutes do
    rake 'moneyforward:import'
  end
  every 1.day, at: '10:00 am' do
    rake 'nitification:reservation'
    rake 'nitification:push_line_message'
  end
end
