# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  def user_login_and_own?(id)
    api_user_signed_in? && current_api_user.id == id
  end

  def host_login_and_own?(id)
    api_host_signed_in? && current_api_host.id == id
  end

  def render_message message, status
    render json: { message: [message]}, status: status
  end
end
