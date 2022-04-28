# frozen_string_literal: true

class Api::Host::HostMessagesController < ApplicationController
  def create
    room = Room.find(params[:room_id])
    return unless host_login_and_own?(room.host.id)

    host_message = HostMessage.new(host_message_params)

    if host_message.save
      render_message = {
        message: host_message.message, created_at: host_message.created_at
      }
      render json: { host_message: render_message }
    else
      render json: host_message.errors, status: :bad_request
    end
  end

  private

  def host_message_params
    params.permit(:room_id, :message)
  end
end
