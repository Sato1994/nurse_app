# frozen_string_literal: true

class Api::UserRequestsController < ApplicationController
  ####################################
  # def index
  #   # 1.存在する自分が関与するAgreementsを取得
  #   # 2.そのうちstateが0の現在時刻より6時間以内ののものは全削除
  #   # 3.そのうちstateが3～5のものは配列から除外する
  #   # 4.そのうちstateが1のものは勤務時間であればにstateを2に変更。
  #   # 5.そのうちstateが1か2のもののうち勤務時間を超えていれば3へ変更
  #   if api_user_signed_in?
  #     Agreement.where('user_id = ? && start_time < ? && state = 0', current_api_user.id, Time.current + 6.hour).destroy_all
  #     Agreement.where('user_id = ? && start_time <= ? && ? <= finish_time && state = 1', current_api_user.id, Time.current, Time.current).update_all(state: 2)
  #     Agreement.where('user_id = ? && finish_time < ? && (state = 1 || 2)', current_api_user.id, Time.current).update_all(state: 3)
  #     @agreements =Agreement.where('user_id = ?', current_api_user.id)

  #   elsif api_user_signed_in?
  #     Agreement.where('user_id = ? && start_time < ? && state = ?', current_api_user.id, Time.current + 6.hour, 0).destroy_all
  #     Agreement.where('user_id = ? && start_time <= ? && ? <= finish_time && state = 1', current_api_user.id, Time.current, Time.current).update_all(state: 2)
  #     Agreement.where('user_id = ? && finish_time < ? && (state = 1 || 2)', current_api_user.id, Time.current).update_all(state: 3)
  #     @agreements =Agreement.where('user_id = ?', current_api_user.id)
  #   else
  #     render body: nil, status: 401
  #     return
  #   end
  #   render "index", formats: :json, handlers: :jbuilder
  # end
  #############################################################

  # user_request作成
  def create
    user_request = UserRequest.new(user_request_params)
    if user_request.save
      recruitment_time = RecruitmentTime.find(params[:recruitment_time_id])
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
