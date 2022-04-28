# frozen_string_literal: true

class Api::User::UserMessagesController < ApplicationController
  def create
    room = Room.find(params[:room_id])
    return unless user_login_and_own?(room.user.id)

    user_message = UserMessage.new(user_message_params)
    
    if user_message.save
      render_message = {
        message: user_message.message, created_at: user_message.created_at
      }
      render json: { user_message: render_message }
    else
      render json: user_message.errors, status: :bad_request
    end
  end

  private

  def user_message_params
    params.permit(:room_id, :message)
  end
end
