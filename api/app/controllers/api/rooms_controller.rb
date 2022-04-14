# frozen_string_literal: true

class Api::RoomsController < ApplicationController
  def show
    room = Room.includes(:user, :host, :user_messages, :host_messages, :agreement).find(params[:id])

    unless user_login_and_own?(room.user.id) || host_login_and_own?(room.host.id)
      render json: nil, status: :unauthorized
      return
    end

    if api_user_signed_in?
      render_room = room.as_json(
        only: %i[id start_time finish_time state closed],
        include: {
          host: {
            only: %i[id name myid image]
          },
          user_messages: {
            only: %i[message created_at]
          },
          host_messages: {
            only: %i[message created_at]
          }
        }
      )

      render_room['partner'] = render_room.delete('host')

      render_agreement = room.agreement.as_json(
        only: %i[id start_time finish_time state]
      )

      render json: { room: render_room, agreement: render_agreement }

    elsif api_host_signed_in?
      render_room = room.as_json(
        only: %i[id start_time finish_time state closed],
        include: {
          user: {
            only: %i[id name myid image]
          },
          user_messages: {
            only: %i[message created_at]
          },
          host_messages: {
            only: %i[message created_at]
          }
        }
      )

      render_room['partner'] = render_room.delete('user')

      render_agreement = room.agreement.as_json(
        only: %i[id start_time finish_time state]
      )

      render json: { room: render_room, agreement: render_agreement }

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

      if api_user_signed_in?
        room.create_host_notice!(host_id: room.host_id, action: 'created')
      elsif api_host_signed_in?
        room.create_user_notice!(user_id: room.user_id, action: 'created')
      end

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

      if room.update(room_user_signed_in_params_update)
        room.create_host_notice_with_checked_validate!(host_id: room.host_id, action: 'changed')

        render_room = {
          start_time: room.start_time, finish_time: room.finish_time
        }

        render json: {room: render_room}

      else
        render json: room.errors, status: :bad_request
      end

    elsif host_login_and_own?(room.host.id)

      if room.update(room_host_signed_in_params_update)
        room.create_user_notice_with_checked_validate!(user_id: room.user_id, action: 'changed')

        render_room = {
          start_time: room.start_time, finish_time: room.finish_time
        }

        render json: {room: render_room}

      else
        render json: room.errors, status: :bad_request
      end

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
        case negotiating_to
        when 'user'
          room.create_host_notice_with_checked_validate!(host_id: room.host_id, action: 'agreed')
        when 'host'
          room.create_user_notice_with_checked_validate!(user_id: room.user_id, action: 'agreed')
        end
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
      if room.update(closed: na_to)
        case na_to
        when 'user'
          room.create_host_notice!(host_id: room.host_id, action: 'left')

        when 'host'
          room.create_user_notice!(user_id: room.user_id, action: 'left')
        end

      end

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
