class Api::RecruitmentTimesController < ApplicationController

  def create
    recruitment_time = RecruitmentTime.new(recruitment_time_params)
    if recruitment_time.save
      render json: recruitment_time, status: 201
    else 
      render json: recruitment_time.errors, status: 400
    end
  end




  private

  def recruitment_time_params
    params.permit(:recruitment_time).merge(host: current_api_host, start_time:Time.zone.parse(params[:start_time]), finish_time: Time.zone.parse(params[:finish_time]))
  end

end
