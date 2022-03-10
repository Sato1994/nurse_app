# frozen_string_literal: true

class Api::UsersController < ApplicationController
  include Pagination

  def index
    # skillが被っていないuserのidの配列の作成
    lower_year = params[:lowerYear].to_i
    address = params[:address]
    wanted = params[:wanted]

    host_skill_ids = []
    host_skill_ids.push(params[:skillsId].map(&:to_i)).flatten! if params[:skillsId].present?

    all_users = User.includes(:user_skills)

    target_users_id = []

    all_users.each do |user|
      skills = user.user_skills
      user_skill_ids = []

      skills.each do |skill|
        user_skill_ids.push(skill.skill_id)
      end

      user_skill_ids.push(host_skill_ids)
      user_skill_ids.flatten!
      mixed_skill_ids = user_skill_ids.uniq

      target_users_id.push(user.id) if mixed_skill_ids.length == user_skill_ids.length
    end

    # user検索
    users = Kaminari.paginate_array(User.all.year_gt(lower_year).address_like(address).wanted_true(wanted).id_include(
                                      target_users_id, params[:skillsId]
                                    )).page(params[:page]).per(10)

    pagination = resources_with_pagination(users)
    @object = {
      users: users.as_json, kaminari: pagination
    }
    render json: @object
  end

  def show
    # !で、レコードが見つからない場合nilでなくて404を発生させられる。
    # 個人のページのURLをmyidにする。
    if api_user_signed_in? && current_api_user.myid == params[:id]
      @user = current_api_user
      @requests = current_api_user.user_requests
      @offers = current_api_user.host_requests
      @agreements = current_api_user.agreements
      @rooms = current_api_user.rooms
      @skills = current_api_user.skills
      @free_times = current_api_user.free_times
    else
      @user = User.find_by!(myid: params[:id])
      @free_times = @user.free_times
      @skills = @user.skills
    end
    render 'show', formats: :json, handlers: :jbuilder
  end
end
