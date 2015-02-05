# This file is used by Rack-based servers to start the application.

# Horrendous hack to allow us to run sidekiq jobs within the same free dyno
# # as the web process.
if ENV["RAILS_ENV"] == "production" || ENV["RACK_ENV"] == "production"
  fork do
    Process.exec("bundle exec sidekiq")
  end
end

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
