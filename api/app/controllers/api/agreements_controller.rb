class Api::AgreementsController < ApplicationController

  def index
    # 1.存在する自分が関与するAgreementsを取得
    # 2.そのうちstateが0の現在時刻より6時間以内ののものは全削除
    # 3.そのうちstateが3～5のものは配列から除外する
    # 4.そのうちstateが1のものは勤務時間であればにstateを2に変更。
    # 5.そのうちstateが1か2のもののうち勤務時間を超えていれば3へ変更
    if api_user_signed_in?
      Agreement.where('user_id = ? && start_time < ? && state = 0', current_api_user.id, Time.current + 6.hour).destroy_all
      Agreement.where('user_id = ? && start_time <= ? && ? <= finish_time && state = 1', current_api_user.id, Time.current, Time.current).update_all(state: 2)
      Agreement.where('user_id = ? && finish_time < ? && (state = 1 || 2)', current_api_user.id, Time.current).update_all(state: 3)
      @agreements =Agreement.where('user_id = ?', current_api_user.id)

    elsif api_host_signed_in?
      Agreement.where('host_id = ? && start_time < ? && state = ?', current_api_host.id, Time.current + 6.hour, 0).destroy_all
      Agreement.where('host_id = ? && start_time <= ? && ? <= finish_time && state = 1', current_api_host.id, Time.current, Time.current).update_all(state: 2)
      Agreement.where('host_id = ? && finish_time < ? && (state = 1 || 2)', current_api_host.id, Time.current).update_all(state: 3)
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
    params.permit(:state).merge(user: current_api_user, host: @host, start_time: Time.zone.parse(params[:start_time]), finish_time: Time.zone.parse(params[:finish_time]))
  end

  def agreement_host_signed_in_params
    params.permit(:state).merge(user: @user, host: current_api_host, start_time: Time.zone.parse(params[:start_time]), finish_time: Time.zone.parse(params[:finish_time]))
  end







end
