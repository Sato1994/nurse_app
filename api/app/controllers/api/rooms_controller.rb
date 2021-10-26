class Api::RoomsController < ApplicationController

  def create
    if api_user_signed_in?
      @host = Host.find(params[:host_id])
      room = Room.new(room_user_signed_in_params)
      if room.save
        render json: room, status: 201
      else
        render json: room.errors, status: 400
      end
    elsif api_host_signed_in?
      @user = User.find(params[:user_id])
      room = Room.new(room_host_signed_in_params)
      if room.save
        render json: room, status: 201
      else
        render json: room.errors, status: 400
      end
    else
      render body: nil, status: 401
    end
  end
  
  private

  def room_user_signed_in_params
    params.permit(:user, :host).merge(user: current_api_user, host: @host)
  end

  def room_host_signed_in_params
    params.permit(:user, :host).merge(user: @user, host: current_api_host)
  end

end
