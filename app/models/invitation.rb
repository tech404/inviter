require "slack/client"

class Invitation
  include Virtus.model
  include ActiveModel::Model

  attribute :email, String
  validates :email, presence: true

  def enqueue
    InvitationWorker.perform_async(attributes)
  end

  def perform
    slack_client.invite \
      email:    email,
      channels: ENV["SLACK_CHANNELS"].to_s.split(/\s*,\s*/)
  end

  private
  def slack_client
    @slack_client ||= Slack::Client.new \
      subdomain: ENV.fetch("SLACK_SUBDOMAIN"),
      token:     ENV.fetch("SLACK_TOKEN")
  end
end
