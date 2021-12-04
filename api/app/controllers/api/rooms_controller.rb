class Api::RoomsController < ApplicationController
  
  def show
    @room = Room.find(params[:id])
    @user_messages = @room.user_messages
    @host_messages = @room.host_messages
    @start_time = @room.start_time
    @finish_time = @room.finish_time
    @state = @room.state
    @closed = @room.closed
    if api_user_signed_in? && current_api_user = @room.user
      @partner = @room.host
      render "show", formats: :json, handlers: :jbuilder
      # render json: nil, status: 403
    elsif api_host_signed_in? && current_api_host = @room.host
      @partner = @room.user
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
        render json: {id: room.id, state: room.state, closed: room.closed, user: room.user, host: room.host, created_at: room.created_at}, status: 201
      else
        render json: room.errors, status: 400
      end
    elsif api_host_signed_in?
      user = User.find(params[:user_id])
      room = Room.new(room_host_signed_in_params)
      if room.save
        UserRequest.find(params[:request_id]).destroy
        render json: {id: room.id, state: room.state, closed: room.closed, user: room.user, host: room.host, created_at: room.created_at}, status: 201
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
        case room.state
        when "negotiating"
          if room.update(state: "user")
            render json: room, status: 200
          else
            render json: room.errors, status: 400
          end
        when "user"
          if room.update(state: "negotiating")
            render json: room, status: 200
          else
            render json: room.errors, status: 400
          end
        when "host"
          if room.update(state: "conclusion")
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
        case room.state
        when "negotiating"
          if room.update(state: "host")
            render json: room, status: 200
          else
            render json: room.errors, status: 400
          end
        when "user"
          if room.update(state: "conclusion")
            render json: room, status: 200
          else
            render json: room.errors, status: 400
          end
        when "host"
          if room.update(state: "negotiating")
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

  def cancell_room
    room = Room.find(params[:id])
    if api_user_signed_in? && current_api_user === room.user
      case room.closed
      when "na"
        closed_value = "user"
      when "host"
        closed_value = "both"
      end
      state_value = "cancelled"
      room.update_state(state_value)
      room.update_closed(closed_value)
      render json: {state: room.state, closed: room.closed}
    elsif api_host_signed_in? && current_api_host === room.host
      case room.closed
      when "na"
        closed_value = "host"
      when "user"
        closed_value = "both"
      end
      state_value = "cancelled"
      room.update_state(state_value)
      room.update_closed(closed_value)
      render json: {state: room.state, closed: room.closed}
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
