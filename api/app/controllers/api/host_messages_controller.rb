class Api::HostMessagesController < ApplicationController

  def create
    room = Room.find(params[:room_id])
    if room.host = current_api_host
      host_message = HostMessage.new(host_message_params)
      if host_message.save
        render json: host_message, status: 201
      else
        render json: host_message.errors, status: 400
      end
    else
      render json: nil, status: 401
    end
  end



  private

  def host_message_params
    params.permit(:room_id, :message)
  end
end
