# frozen_string_literal: true

class Api::UserRequestsController < ApplicationController
  def index
    UserRequest.where('user_id = ? && start_time <= ?', params[:id], 7.hours.from_now).destroy_all

    render_user_requests = UserRequest.where(user_id: params[:id]).includes(:host).as_json(
      only: %i[id start_time finish_time],
      include: {
        host: {
          only: %i[id name image myid]
        }
      }
    )

    render_user_requests.each do |request|
      request['partner'] = request.delete('host')
    end

    render json: {
      requests: render_user_requests
    }
  end

  # user_request作成
  def create
    user_request = UserRequest.new(user_request_params)

    if user_request.save
      recruitment_time = RecruitmentTime.find(params[:recruitment_time_id])
      user_request.create_host_notice!(host_id: recruitment_time.host_id, action: 'created')
      render json: { id: user_request.id, start_time: user_request.start_time, finish_time: user_request.finish_time,
                     partner: recruitment_time.host },
             status: :created
    else
      render json: user_request.errors, status: :bad_request
    end
  end

  def destroy
    user_request = UserRequest.find(params[:id])
    recruitment_time = RecruitmentTime.find(user_request.recruitment_time_id)
    return unless user_login_and_own?(user_request.user_id) || host_login_and_own?(recruitment_time.host_id)

    user_request.destroy
  end

  private

  def user_request_params
    params.permit(:recruitment_time_id).merge(user_id: current_api_user.id, start_time: Time.zone.parse(params[:start_time]),
                                              finish_time: Time.zone.parse(params[:finish_time]))
  end
end
