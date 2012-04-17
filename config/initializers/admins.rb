config = YAML.load_file("#{Rails.root}/config/admins.yml")
Rails.application.config.admins = config['usernames']
