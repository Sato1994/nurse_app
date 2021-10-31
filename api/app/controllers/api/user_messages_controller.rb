class Api::UserMessagesController < ApplicationController

  def create
    room = Room.find(params[:room_id])
    if room.user = current_api_user
      user_message = UserMessage.new(user_message_params)
      if user_message.save
        render json: user_message, status: 201
      else
        render json: user_message.errors, status: 400
      end
    else
      render json: nil, status: 401
    end
  end



  private

  def user_message_params
    params.permit(:room_id, :message)
  end









end
