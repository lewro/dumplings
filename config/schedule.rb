directory = @environment == 'production' ? 'production' : 'test'

set :output, "/var/www/sites/dumplings/current/log/whenever.log"

every 30.day, :at => "5:00 am" do
  runner "Task.check_tasks_every_month"
end

every 7.day, :at => "5:00 am" do
  runner "Task.check_tasks_every_week"
end

every 1.day, :at => "5:00 am" do
  runner "Task.check_tasks_every_day"
end

every 1.minute do
  runner "Task.check_tasks_every_minute"
end
