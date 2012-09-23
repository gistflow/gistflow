namespace :db do
  task backup: [:dump, :upload_backup] do
  end
  
  task upload_backup: :environment do
    cf = CloudFiles::Connection.new(
      username: Configuration.rackspace.username,
      api_key:  Configuration.rackspace.api_key,
      auth_url: CloudFiles::AUTH_UK
    )
    container = cf.container('db_backups')
    name = "backup_#{Time.current.strftime('%Y_%m_%d_%H_%M_%S')}"
    file = File.open Rails.root.join('db', 'data.yml')
    backup = container.create_object name, false
    backup.write file
    file.close
  end
end