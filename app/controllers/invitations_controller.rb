class InvitationsController < ApplicationController
  before_action :authenticate

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

  def authenticate
    return true if (ENV['HTTP_BASIC_USER'].nil? || ENV['HTTP_BASIC_PASSWORD'].nil?)

    authenticate_or_request_with_http_basic do |user, password|
      user == ENV['HTTP_BASIC_USER'] && password == ENV['HTTP_BASIC_PASSWORD']
    end
  end
end
