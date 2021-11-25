class Api::AgreementsController < ApplicationController

  def index
    # 1.存在する自分が関与するAgreementsを取得
    # 3.そのうちstateが2～4のものは配列から除外する
    # 4.そのうちstateが0のものは勤務時間であればにstateを1に変更。
    # 5.そのうちstateが0か1のもののうち勤務時間を超えていれば2へ変更
    if api_user_signed_in?
      Agreement.where('user_id = ? && start_time <= ? && ? <= finish_time && state = 0', current_api_user.id, Time.current, Time.current).update_all(state: 1)
      Agreement.where('user_id = ? && finish_time < ? && (state = 0 || 1)', current_api_user.id, Time.current).update_all(state: 2)
      @agreements =Agreement.where('user_id = ?', current_api_user.id)

    elsif api_host_signed_in?
      Agreement.where('host_id = ? && start_time <= ? && ? <= finish_time && state = 0', current_api_host.id, Time.current, Time.current).update_all(state: 1)
      Agreement.where('host_id = ? && finish_time < ? && (state = 0 || 1)', current_api_host.id, Time.current).update_all(state: 2)
      @agreements =Agreement.where('host_id = ?', current_api_host.id)
    else
      render body: nil, status: 401
      return
    end
    render "index", formats: :json, handlers: :jbuilder
  end

  def create
    if api_user_signed_in?
      @host = Host.find(params[:host_id])
      agreement = Agreement.new(agreement_user_signed_in_params)
      if agreement.save
        render json: agreement, status: 201
      else
        render json: agreement.errors, status: 400
      end
    elsif api_host_signed_in?
      @user = User.find(params[:user_id])
      agreement = Agreement.new(agreement_host_signed_in_params)
      if agreement.save
        render json: agreement, status: 201
      else
        render json: agreement.errors, status: 400
      end
    else
      render body: nil, status: 401
    end
  end

  # def update
  #   agreement = Agreement.find(params[:id])
  #   if api_user_signed_in?
  #     @host = agreement.host
  #     if agreement.update(agreement_user_signed_in_params)
  #       render json: agreement, status: 200
  #     else
  #       render json: agreement.errors, status: 400
  #     end
  #   elsif api_host_signed_in?
  #     @user = agreement.user
  #     if agreement.update(agreement_host_signed_in_params)
  #       render json: agreement, status: 200
  #     else
  #       render json: agreement.errors, status: 400
  #     end
  #   else
  #     render body: nil, status: 401
  #   end
  # end

  # def destroy
  #   agreement = Agreement.find(params[:id])
  #   if agreement.destroy
  #     render body: nil, status: 204
  #   else
  #     render json: agreement.errors, status: 400
  #   end
  # end

  private

  def agreement_user_signed_in_params
    params.permit(:host_id, :room_id, :state).merge(user_id: current_api_user.id, start_time: Time.zone.parse(params[:start_time]), finish_time: Time.zone.parse(params[:finish_time]))
  end

  def agreement_host_signed_in_params
    params.permit(:user_id, :room_id, :state).merge(host_id: current_api_host.id, start_time: Time.zone.parse(params[:start_time]), finish_time: Time.zone.parse(params[:finish_time]))
  end
end
