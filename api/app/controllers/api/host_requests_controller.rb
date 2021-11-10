class Api::HostRequestsController < ApplicationController

  def create
    host_request = HostRequest.new(host_request_params)
    if host_request.save
      render json: host_request, status: 201
    else
      render json: host_request.errors, status: 400
    end
  end

  private

  def host_request_params
    params.permit(:host_request).merge(free_time_id: params[:free_time_id], host: current_api_host, start_time:Time.zone.parse(params[:start_time]), finish_time: Time.zone.parse(params[:finish_time]))
  end
  
end
