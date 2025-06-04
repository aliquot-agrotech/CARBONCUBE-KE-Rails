set :output, "log/cron.log"
env :PATH, ENV['PATH']

every 1.day, at: '12:00 am' do
  rake "documents:send_reminders"
end
