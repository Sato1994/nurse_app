class Api::HostRequestsController < ApplicationController

  ########## host_request作成 ##########
  def create
    host_request = HostRequest.new(host_request_params)
    if host_request.save
      free_time = FreeTime.find(params[:free_time_id])
      render json: {id: host_request.id, start_time: host_request.start_time, finish_time: host_request.finish_time, user: free_time.user }, status: 201
    else
      render json: host_request.errors, status: 400
    end
  end

  private

  def host_request_params
    params.permit(:free_time_id).merge(host_id: current_api_host.id, start_time:Time.zone.parse(params[:start_time]), finish_time: Time.zone.parse(params[:finish_time]))
  end
  
end