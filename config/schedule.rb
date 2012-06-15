set :output, "/u/apps/gistflow/shared/log/cron_log.log"

every 4.hours do
  rake 'db:backup'
end
