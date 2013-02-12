set :output, "/u/apps/gistflow/shared/log/cron_log.log"

every 4.hours do
  rake 'db:backup'
end

every 1.day do
  rake 'time_counters:generate_todays'
end

every 1.day do
  rake 'users:fetch_locations'
end
