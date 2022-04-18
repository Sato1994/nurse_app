# frozen_string_literal: true

class Api::FreeTimesController < ApplicationController
  def index
    FreeTime.where('user_id = ? && start_time <= ?', params[:id], 8.hours.from_now).destroy_all

    render json: {
      times: FreeTime.where(user_id: params[:id]).as_json(
        only: %i[id start_time finish_time]
      )
    }
  end

  def create
    free_time = FreeTime.new(free_time_params)
    if free_time.save
      render json: free_time, status: :created
    else
      render json: free_time.errors, status: :bad_request
    end
  end

  def destroy
    free_time = FreeTime.find(params[:id])
    return unless user_login_and_own?(free_time.user_id)

    free_time.destroy
  end

  private

  def free_time_params
    params.permit(:free_time).merge(user: current_api_user, start_time: Time.zone.parse(params[:start_time]),
                                    finish_time: Time.zone.parse(params[:finish_time]))
  end
end
