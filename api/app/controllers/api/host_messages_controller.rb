# frozen_string_literal: true

class Api::HostMessagesController < ApplicationController
  def create
    room = Room.find(params[:room_id])
    if room.host = current_api_host
      host_message = HostMessage.new(host_message_params)
      if host_message.save
        render json: { id: host_message.id, message: host_message.message, name: room.host.name, created_at: host_message.created_at },
               status: :created
      else
        render json: host_message.errors, status: :bad_request
      end
    else
      render json: nil, status: :unauthorized
    end
  end

  private

  def host_message_params
    params.permit(:room_id, :message)
  end
end
