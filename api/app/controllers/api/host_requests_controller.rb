# frozen_string_literal: true

class Api::HostRequestsController < ApplicationController
  # host_request作成
  def create
    host_request = HostRequest.new(host_request_params)
    if host_request.save
      free_time = FreeTime.find(params[:free_time_id])
      render json: { id: host_request.id, start_time: host_request.start_time, finish_time: host_request.finish_time, partner: free_time.user },
             status: :created
    else
      render json: host_request.errors, status: :bad_request
    end
  end

  private

  def host_request_params
    params.permit(:free_time_id).merge(host_id: current_api_host.id, start_time: Time.zone.parse(params[:start_time]),
                                       finish_time: Time.zone.parse(params[:finish_time]))
  end
end
