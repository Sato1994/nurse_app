# frozen_string_literal: true

class Api::Issue::HostRequestsController < ApplicationController
  def index
    # Host本人のrequestが無効だった場合
    if api_host_signed_in?
      HostRequest.where('host_id = ? && start_time <= ?', params[:id], 7.hours.from_now).destroy_all

      render_host_requests = HostRequest.where(host_id: params[:id])
                                        .includes(:user)
                                        .as_json(
                                          only: %i[id start_time finish_time],
                                          include: {
                                            user: {
                                              only: %i[id name image myid]
                                            }
                                          }
                                        )

      render_host_requests.each do |request|
        request['partner'] = request.delete('user')
      end

      render json: {
        requests: render_host_requests
      }

    elsif api_user_signed_in?
      # Userがもらったoffersが無効だった場合
      HostRequest.left_joins(:free_time).includes(free_time: :user)
                 .where('host_requests.start_time <= ?', 7.hours.from_now)
                 .merge(FreeTime.where(user_id: current_api_user.id))
                 .destroy_all

      render_host_requests = HostRequest.left_joins(:free_time)
                                        .includes(free_time: :user)
                                        .merge(FreeTime.where(user_id: current_api_user.id))
                                        .as_json(
                                          only: %i[id start_time finish_time],
                                          include: {
                                            host: {
                                              only: %i[id name image myid]
                                            }
                                          }
                                        )
      render_host_requests.each do |request|
        request['partner'] = request.delete('host')
      end

      render json: {
        offers: render_host_requests
      }
    else
      render json: nil, status: :unauthorized
    end
  end

  def create
    host_request = HostRequest.new(host_request_params)
    if host_request.save
      free_time = FreeTime.find(params[:free_time_id])
      host_request.create_user_notice!(user_id: free_time.user_id, action: 'created')
      render json: { id: host_request.id, start_time: host_request.start_time, finish_time: host_request.finish_time,
                     partner: free_time.user },
             status: :created
    else
      render json: host_request.errors, status: :bad_request
    end
  end

  def destroy
    host_request = HostRequest.find(params[:id])
    free_time = FreeTime.find(host_request.free_time_id)
    return unless host_login_and_own?(host_request.host_id) || user_login_and_own?(free_time.user_id)

    host_request.destroy
  end

  private

  def host_request_params
    params.permit(:free_time_id).merge(host_id: current_api_host.id, start_time: Time.zone.parse(params[:start_time]),
                                       finish_time: Time.zone.parse(params[:finish_time]))
  end
end
