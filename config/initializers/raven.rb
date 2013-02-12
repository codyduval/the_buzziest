require 'raven'

SENTRY_DSN = 'https://27c7b1d1bf774ccabf7bf2da0d7154a9:07a150981b464fb6813237ff7eb60255@app.getsentry.com/5433'

Raven.configure do |config|
  config.dsn = 'SENTRY_DSN'
end