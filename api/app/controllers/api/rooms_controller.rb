class Api::RoomsController < ApplicationController
  
  def show
    room = Room.find(params[:id])
    @user_messages = UserMessage.where(room: room)
    @host_messages = HostMessage.where(room: room)
    @start_time = room.start_time
    @finish_time = room.finish_time
    @consensus = room.consensus
    if api_user_signed_in? && current_api_user = room.user
      @partner = room.host
      render "show", formats: :json, handlers: :jbuilder
      # render json: nil, status: 403
    elsif api_host_signed_in? && current_api_host = room.host
      @partner = room.user
      render "show", formats: :json, handlers: :jbuilder
      # render json: nil, status: 403
    else
      render json: nil , status: 401
    end
  end

  def create
    if api_user_signed_in?
      room = Room.new(room_user_signed_in_params)
      if room.save
        HostRequest.find(params[:request_id]).destroy
        render json: room, status: 201
      else
        render json: room.errors, status: 400
      end
    elsif api_host_signed_in?
      user = User.find(params[:user_id])
      room = Room.new(room_host_signed_in_params)
      if room.save
        UserRequest.find(params[:request_id]).destroy
        render json: room, status: 201
      else
        render json: room.errors, status: 400
      end
    else
      render body: nil, status: 401
    end
  end

  def update
    room = Room.find(params[:id])
    if api_user_signed_in? && current_api_user = room.user
      if params[:start_time] 
        if room.update(room_user_signed_in_params)
          render json: room, status: 200
        else
          render json: room.errors, status: 400
        end
      else
        case room.consensus
        when "negotiating"
          if room.update(consensus: "user")
            render json: room, status: 200
          else
            render json: room.errors, status: 400
          end
        when "user"
          if room.update(consensus: "negotiating")
            render json: room, status: 200
          else
            render json: room.errors, status: 400
          end
        when "host"
          if room.update(consensus: "conclusion")
            render json: room, status: 200
          else
            render json: room.errors, status: 400
          end
        else
          render body: nil, status: 400
        end
      end
    elsif api_host_signed_in? && current_api_host = room.host
      if params[:start_time] 
        if room.update(room_host_signed_in_params)
          render json: room, status: 200
        else
          render json: room.errors, status: 400
        end
      else
        case room.consensus
        when "negotiating"
          if room.update(consensus: "host")
            render json: room, status: 200
          else
            render json: room.errors, status: 400
          end
        when "user"
          if room.update(consensus: "conclusion")
            render json: room, status: 200
          else
            render json: room.errors, status: 400
          end
        when "host"
          if room.update(consensus: "negotiating")
            render json: room, status: 200
          else
            render json: room.errors, status: 400
          end
        else
          render body: nil, status: 400
        end
      end
    else
      render body:nil, status: 403
    end
  end

  private

  def room_user_signed_in_params
    params.permit(:host_id).merge(user_id: current_api_user.id, start_time: Time.zone.parse(params[:start_time]), finish_time: Time.zone.parse(params[:finish_time]))
  end

  def room_host_signed_in_params
    params.permit(:user_id).merge(host_id: current_api_host.id, start_time: Time.zone.parse(params[:start_time]), finish_time: Time.zone.parse(params[:finish_time]))
  end
end
