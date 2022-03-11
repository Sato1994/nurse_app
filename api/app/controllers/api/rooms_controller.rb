# frozen_string_literal: true

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
      render 'show', formats: :json, handlers: :jbuilder
      # render json: nil, status: 403
    elsif api_host_signed_in? && current_api_host = @room.host
      @partner = @room.user
      render 'show', formats: :json, handlers: :jbuilder
      # render json: nil, status: 403
    else
      render json: nil, status: :unauthorized
    end
  end

  def create
    if api_user_signed_in?
      method = room_user_signed_in_params
      request = 'Host'
    elsif api_host_signed_in?
      method = room_host_signed_in_params
      request = 'User'
    else
      render body: nil, status: :unauthorized
      return
    end
    room = Room.new(method)
    if room.save
      eval("#{request}Request").find(params[:request_id]).destroy
      render json: { id: room.id, state: room.state, closed: room.closed, user: room.user,
                     host: room.host, created_at: room.created_at },
             status: :created
    else
      render json: room.errors, status: :bad_request
    end
  end

  def update_room_time
    room = Room.find(params[:id])
    if user_login_and_own?(room.user.id)
      # 時間が更新される
      render json: room.errors, status: :bad_request unless room.update(room_user_signed_in_params)
    elsif host_login_and_own?(room.host.id)
      render json: room.errors, status: :bad_request unless room.update(room_host_signed_in_params)
    else
      render body: nil, status: :forbidden
    end
  end

  def update_room_state
    room = Room.find(params[:id])
    if user_login_and_own?(room.user.id)
      negotiating_to = 'user'
      user_to = 'negotiating'
      host_to = 'conclusion'

    elsif host_login_and_own?(room.host.id)
      negotiating_to = 'host'
      user_to = 'conclusion'
      host_to = 'negotiating'
    else
      render body: nil, status: :forbidden
      return
    end

    case room.state
    when 'negotiating'
      if room.update(state: negotiating_to)
        render json: room, status: :ok
      else
        render json: room.errors, status: :bad_request
      end
    when 'user'
      if room.update(state: user_to)
        render json: room, status: :ok
      else
        render json: room.errors, status: :bad_request
      end
    when 'host'
      if room.update(state: host_to)
        render json: room, status: :ok
      else
        render json: room.errors, status: :bad_request
      end
    else
      render body: nil, status: :bad_request
    end
  end

  def cancell_room
    room = Room.find(params[:id])
    if user_login_and_own?(room.user.id)
      na_to = 'user'
    elsif host_login_and_own?(room.host.id)
      na_to = 'host'
    else
      render body: nil, status: :forbidden
      return
    end

    case room.closed
    when 'na'
      room.update(closed: na_to)
    when 'host' || 'user'
      room.update(closed: 'both')
    else
      render body: nil, status: :bad_request
    end
    room.update(state: 'cancelled')
    render json: { state: room.state, closed: room.closed }
  end

  private

  def room_user_signed_in_params
    params.permit(:host_id).merge(user_id: current_api_user.id, start_time: Time.zone.parse(params[:start_time]),
                                  finish_time: Time.zone.parse(params[:finish_time]))
  end

  def room_host_signed_in_params
    params.permit(:user_id).merge(host_id: current_api_host.id, start_time: Time.zone.parse(params[:start_time]),
                                  finish_time: Time.zone.parse(params[:finish_time]))
  end
end
