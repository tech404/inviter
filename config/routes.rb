Rails.application.routes.draw do
  get "/_ping", to: Proc.new { |env| [200, {"Content-Type" => "text/plain"}, []] }

  resources :invitations, only: [:create]

  require "sidekiq/web"
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end if Rails.env.production?
  mount Sidekiq::Web, at: "/sidekiq"
end
