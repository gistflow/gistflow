rails_env = 'production'
worker_processes 4
preload_app true
timeout 30
listen '/u/apps/gistflow/shared/tmp/sockets/unicorn.sock'