namespace :db do
  task backup: [:dump, :upload_backup, :keep_releases] do
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

  task keep_releases: :environment do
    cf = CloudFiles::Connection.new(
      username: Configuration.rackspace.username,
      api_key:  Configuration.rackspace.api_key,
      auth_url: CloudFiles::AUTH_UK
    )
    container = cf.container('db_backups')
    old = container.objects.find_all do |name|
      year, month, day = $1.to_i, $2.to_i, $3.to_i
      p [year, month, day]
      date = name.match(/backup_(\d+)_(\d+)_(\d+)/) { Date.new(year, month, day) }
      date < (Date.current - 2.weeks)
    end

    old.each do |name|
      container.delete_object(name)
    end
  end
end