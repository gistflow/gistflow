rails_env = 'production'
worker_processes 4
preload_app true
timeout 30
pid '/u/apps/gistflow/shared/pids/unicorn.pid'
listen '/u/apps/gistflow/shared/tmp/sockets/unicorn.sock'