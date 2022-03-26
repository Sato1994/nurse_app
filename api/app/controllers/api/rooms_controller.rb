# frozen_string_literal: true

class Api::RoomsController < ApplicationController
  def show
    @room = Room.find(params[:id])
    if user_login_and_own?(@room.user.id)
      @partner = @room.host
      @user_messages = @room.user_messages
      @host_messages = @room.host_messages
      @start_time = @room.start_time
      @finish_time = @room.finish_time
      @state = @room.state
      @closed = @room.closed
      render 'show', formats: :json, handlers: :jbuilder
    elsif host_login_and_own?(@room.host.id)
      @user_messages = @room.user_messages
      @host_messages = @room.host_messages
      @start_time = @room.start_time
      @finish_time = @room.finish_time
      @state = @room.state
      @closed = @room.closed
      @partner = @room.user
      render 'show', formats: :json, handlers: :jbuilder
    else
      render json: nil, status: :unauthorized
    end
  end

  def create
    if api_user_signed_in?
      request = 'Host'
      host_request = HostRequest.find(params[:request_id])

      payload = { user_id: current_api_user.id, host_id: host_request.host_id, start_time: host_request.start_time,
                  finish_time: host_request.finish_time }

    elsif api_host_signed_in?
      request = 'User'
      user_request = UserRequest.find(params[:request_id])

      payload = { user_id: user_request.user_id, host_id: current_api_host.id, start_time: user_request.start_time,
                  finish_time: user_request.finish_time }

    else
      render body: nil, status: :unauthorized
      return
    end
    room = Room.new(payload)
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
      render json: room.errors, status: :bad_request unless room.update(room_user_signed_in_params_update)
    elsif host_login_and_own?(room.host.id)
      render json: room.errors, status: :bad_request unless room.update(room_host_signed_in_params_update)
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
      # 18時間以上のままで同意したらエラー
      if room.finish_time > (room.start_time + 18.hours)
        render json: { message: ['勤務時間は18時間以内にする必要があります。'] }, status: :bad_request
        return
      end

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

  def room_user_signed_in_params_update
    params.permit(:host_id).merge(user_id: current_api_user.id, start_time: Time.zone.parse(params[:start_time]),
                                  finish_time: Time.zone.parse(params[:finish_time]))
  end

  def room_host_signed_in_params_update
    params.permit(:user_id).merge(host_id: current_api_host.id, start_time: Time.zone.parse(params[:start_time]),
                                  finish_time: Time.zone.parse(params[:finish_time]))
  end
end
