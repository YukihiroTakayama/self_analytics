require File.expand_path(File.dirname(__FILE__) + "/environment")

ENV.each { |k, v| env(k, v) }
rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env
set :output, "#{Rails.root}/log/cron.log"
env :PATH, ENV['PATH']

if rails_env.to_sym == :production
  every 15.minutes do
    rake 'moneyforward:import'
  end
  every 1.day, at: '10:00 am' do
    rake 'nitification:reservation'
    rake 'nitification:push_line_message'
  end
end