class InvitationsController < ApplicationController
  def create
    @invitation = Invitation.new(invitation_params)
    if @invitation.valid?
      @invitation.enqueue
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private
  def invitation_params
    params.require(:invitation).permit(:email)
  end
end
