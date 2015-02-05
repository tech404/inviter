class InvitationWorker
  include Sidekiq::Worker

  def perform(invitation_params)
    @invitation = Invitation.new(invitation_params)
    @invitation.perform
  end
end
