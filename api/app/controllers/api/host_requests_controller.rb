# frozen_string_literal: true

class Api::HostRequestsController < ApplicationController
  def index
    HostRequest.where('host_id = ? && start_time <= ?', params[:id], 7.hours.from_now).destroy_all

    render_host_requests = HostRequest.where(host_id: params[:id]).includes(:user).as_json(
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
