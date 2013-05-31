require 'yaml'

secret_file = "#{Rails.root}/config/app_secrets.yml"
example_file = "#{Rails.root}/config/app_secrets_example.yml"

if File.exist?(secret_file)
  yaml_data = YAML.load(File.read(secret_file))
  config = yaml_data["default"]
  begin
    config.merge! yaml_data[Rails.env]
  rescue TypeError
      # nothing specified for this environment; do nothing
  end
# Pass to a HashWithIndifferentAccess so that we can use symbols (APP_CONFIG[:key])
  APP_CONFIG = HashWithIndifferentAccess.new(config)

  ENV['TWITTER_CONSUMER_KEY'] = APP_CONFIG['twitter']['consumer_key']
  ENV['TWITTER_CONSUMER_SECRET'] = APP_CONFIG['twitter']['consumer_secret']
  ENV['TWITTER_OAUTH_TOKEN'] = APP_CONFIG['twitter']['oauth_token']
  ENV['TWITTER_OAUTH_TOKEN_SECRET'] = APP_CONFIG['twitter']['oauth_token_secret']
  ENV['SENTRY_DSN'] = APP_CONFIG['raven']['config_dsn']
  ENV['RAILS_SECRET_TOKEN'] = APP_CONFIG['application']['config_secret_token']
else
  yaml_data = YAML.load(File.read(example_file))
  $stderr.puts "WARNING: No config/app_secrets.yml found! Look at config/app_secrets_example.yml for help."
end


