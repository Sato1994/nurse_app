class Api::FreeTimesController < ApplicationController

  # def index
  #   #
  #   #finish_timeまでTime.currentから8時間以下になったfree_timeを削除すると良さそうか。
  #   FreeTime.where('? >= finish_time')
  # end

  def create
    free_time = FreeTime.new(free_time_params)
    if free_time.save
      render json: free_time, status: 201
    else 
      render json: free_time.errors, status: 400
    end
  end

  def destroy
  end

  private

  def free_time_params
    params.permit(:free_time).merge(user: current_api_user, start_time:Time.zone.parse(params[:start_time]), finish_time: Time.zone.parse(params[:finish_time]))
  end

end
