# frozen_string_literal: true

class Api::Issue::AgreementsController < ApplicationController
  before_action :set_me, only: %i[create]

  def in_progress
    if api_user_signed_in?

      Agreement.where(user_id: current_api_user.id).update_to_correct_state

      render_agreements = Agreement.includes(:room, :host)
                                   .where(state: %w[before during requesting], user_id: current_api_user.id)
                                   .as_json(
                                     only: %i[id start_time finish_time state],
                                     include: {
                                       room: {
                                         only: %i[id]
                                       },
                                       host: {
                                         only: %i[name myid phone]
                                       }
                                     }
                                   )

      render_agreements.each do |agreement|
        agreement['partner'] = agreement.delete('host')
      end

      render json: {
        agreements: render_agreements
      }

    elsif api_host_signed_in?

      Agreement.where(host_id: current_api_host.id).update_to_correct_state

      render_agreements = Agreement.includes(:room, :user)
                                   .where(state: %w[before during requesting], host_id: current_api_host.id)
                                   .as_json(
                                     only: %i[id start_time finish_time state],
                                     include: {
                                       room: {
                                         only: %i[id]
                                       },
                                       user: {
                                         only: %i[name myid]
                                       }
                                     }
                                   )

      render_agreements.each do |agreement|
        agreement['partner'] = agreement.delete('user')
      end

      render json: {
        agreements: render_agreements
      }

    end
  end

  # agreement??????????????????????????????
  def create
    room = Room.find(params[:room_id])
    # agreement????????????????????????????????????
    if room.agreement.nil?
      agreement = Agreement.new(eval("agreement_#{@me}_signed_in_params"))

      if agreement.save

        if api_user_signed_in?
          agreement.create_host_notice!(host_id: agreement.host_id, action: 'created')

          render_agreement = {
            id: agreement.id, start_time: agreement.start_time, finish_time: agreement.finish_time,
            state: agreement.state,
            room: {
              id: agreement.room.id
            },
            partner: {
              name: agreement.host.name,
              myid: agreement.host.myid
            }
          }
        elsif api_host_signed_in?
          agreement.create_user_notice!(user_id: agreement.user_id, action: 'created')

          render_agreement = {
            id: agreement.id, start_time: agreement.start_time, finish_time: agreement.finish_time,
            state: agreement.state,
            room: {
              id: agreement.room.id
            },
            partner: {
              name: agreement.user.name,
              myid: agreement.user.myid
            }
          }
        end
        FreeTime.destroy_free_times(@user_id, Time.zone.parse(params[:start_time]),
                                    Time.zone.parse(params[:finish_time]))

        render json: { agreement: render_agreement }, status: :created
      else
        render json: agreement.errors, status: :bad_request

      end

    # agreement???????????????????????????
    elsif room.agreement.update(eval("agreement_#{@me}_signed_in_params"))

      if api_user_signed_in?
        room.agreement.create_host_notice!(host_id: room.agreement.host_id, action: 'agreed')

      elsif api_host_signed_in?
        room.agreement.create_user_notice!(user_id: room.agreement.user_id, action: 'agreed')

      end

      FreeTime.destroy_free_times(@user_id, Time.zone.parse(params[:start_time]),
                                  Time.zone.parse(params[:finish_time]))

      render_agreement = room.agreement.as_json(
        only: %i[id state start_time finish_time]
      )
      render json: { agreement: render_agreement }, status: :ok
    else
      render json: room.agreement.errors, status: :bad_request

    end
  end

  # agreement???????????????
  def update
    agreement = Agreement.find(params[:id])

    if user_login_and_own?(agreement.user.id) || host_login_and_own?(agreement.host.id)
      if agreement.start_time > 24.hours.since
        state = agreement.update_state

        if api_user_signed_in?
          agreement.create_host_notice!(host_id: agreement.host_id, action: 'changed')

        elsif api_host_signed_in?
          agreement.create_user_notice!(user_id: agreement.user_id, action: 'changed')

        end
        render json: state

      else
        render body: nil, status: :bad_request

      end

    else
      render body: nil, status: :forbidden

    end
  end

  # agreement???????????????
  def cancell
    agreement = Agreement.find(params[:id])

    return unless user_login_and_own?(agreement.user_id)

    if agreement.start_time > (48.hours.from_now)
      agreement.create_host_notice!(host_id: agreement.host_id, action: 'cancelled') if agreement.cancell_agreement
      room = agreement.room

      render_room = {
        id: room.id, created_at: room.created_at, start_time: room.start_time, finish_time: room.finish_time, state: room.state, closed: room.closed,
        partner: {
          id: room.host.id, name: room.host.name
        }
      }

      render json: { room: render_room }
    else

      if params[:comment].blank?
        render body: nil, status: :bad_request
        return
      end

      # cancell comment ??????
      cancell_comment = CancellComment.new(cancell_comment_params)

      if cancell_comment.save && agreement.cancell_agreement
        agreement.create_host_notice!(host_id: agreement.host_id, action: 'cancelled')

        room = agreement.room

        render_room = {
          id: room.id, created_at: room.created_at, start_time: room.start_time, finish_time: room.finish_time, state: room.state, closed: room.closed,
          partner: {
            id: room.host.id, name: room.host.name
          }
        }

        render json: { room: render_room, cancell_comment: cancell_comment }
      else
        render body: nil, status: :bad_request
      end
    end
  end

  # before action
  def set_me
    if api_user_signed_in?
      @me = 'user'
      @user_id = current_api_user.id
    elsif api_host_signed_in?
      @me = 'host'
      @user_id = params[:user_id]
    else
      render body: nil, status: :unauthorized
    end
  end

  private

  # ???????????????????????????ruby p57 default values can be set for arguments
  def agreement_user_signed_in_params(start_time = parsed_time(params[:start_time]), finish_time = parsed_time(params[:finish_time]))
    params.permit(:host_id, :room_id).merge(state: 'before', user_id: current_api_user.id, start_time: start_time,
                                            finish_time: finish_time)
  end

  def agreement_host_signed_in_params(start_time = parsed_time(params[:start_time]), finish_time = parsed_time(params[:finish_time]))
    params.permit(:user_id, :room_id).merge(state: 'before', host_id: current_api_host.id, start_time: start_time,
                                            finish_time: finish_time)
  end

  def cancell_comment_params
    params.permit(:comment).merge(agreement_id: params[:id])
  end

  def parsed_time(time)
    Time.zone.parse(time)
  end
end
