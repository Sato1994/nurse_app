# frozen_string_literal: true

class Api::HostMessagesController < ApplicationController
  def create
    room = Room.find(params[:room_id])
    return unless host_login_and_own?(room.host.id)

    host_message = HostMessage.new(host_message_params)
    if host_message.save
      render json: { id: host_message.id, message: host_message.message, name: room.host.name,
                     created_at: host_message.created_at },
             status: :created
    else
      render json: host_message.errors, status: :bad_request
    end
  end

  private

  def host_message_params
    params.permit(:room_id, :message)
  end
end
