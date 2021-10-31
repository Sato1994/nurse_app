class Api::RoomsController < ApplicationController

  def show
     if api_user_signed_in?
      room = Room.find(params[:id])
      if room.user === current_api_user
        @user_messages = UserMessage.where(room: room)
        @host_messages = HostMessage.where(room: room)
        render "show", formats: :json, handlers: :jbuilder
      else
        render json: nil, status: 403
      end
    elsif api_host_signed_in?
      room = Room.find(params[:id])
      if room.host === current_api_host
        @user_messages = UserMessage.where(room: room)
        @host_messages = HostMessage.where(room: room)
        render "show", formats: :json, handlers: :jbuilder
      else
        render json: nil, status: 403
      end
    else
      render json: nil , status: 401
    end
  end

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
