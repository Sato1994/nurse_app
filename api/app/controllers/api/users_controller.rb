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
    if api_user_signed_in? && current_api_user.myid == params[:id]

      user = User.includes([agreements: %i[room host],
                            rooms: :host,
                            user_requests: :host,
                            free_times: [host_requests: :host],
                            user_skills: :skill]).find(current_api_user.id)

      render_user = user.as_json(
        only: %i[id myid name address lat lng image wanted sex age year profile created_at]
      )

      render_agreements = user.agreements.in_progress.as_json(
        only: %i[id start_time finish_time state],
        include: {
          room: {
            only: %i[id]
          },
          host: {
            only: %i[name myid phone]
          }
        }
      )

      # key変更
      render_agreements.each do |agreement|
        agreement['partner'] = agreement.delete('host')
      end

      render_rooms = user.rooms.display_room_for_user.as_json(
        only: %i[id state closed start_time finish_time created_at],
        include: {
          host: {
            only: %i[id name]
          }
        }
      )

      render_rooms.each do |room|
        room['partner'] = room.delete('host')
      end

      render_user_requests = user.user_requests.as_json(
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

      render_free_times = user.free_times.as_json(
        only: %i[id start_time finish_time]
      )

      render_host_requests = user.host_requests.as_json(
        only: %i[id start_time finish_time],
        include: {
          host: {
            only: %i[id name image myid]
          }
        }
      )

      render_host_requests.each do |request|
        request['partner'] = request.delete('host')
      end

      render_user_skills = user.skills.as_json(
        only: %i[name]
      )

      render json: {
        info: render_user, agreements: render_agreements, rooms: render_rooms, requests: render_user_requests,
        times: render_free_times, offers: render_host_requests, skills: render_user_skills
      }

    else
      user = User.includes([
                             free_times: [host_requests: :host],
                             user_skills: :skill
                           ]).find_by(myid: params[:id])

      render_free_times = user.free_times.as_json(
        only: %i[id start_time finish_time]
      )

      render_user_skills = user.skills.as_json(
        only: %i[name]
      )

      render_user = user.as_json(
        only: %i[id myid name address lat lng image wanted sex age year profile created_at]
      )

      render json: {
        info: render_user, times: render_free_times, skills: render_user_skills
      }
    end
  end
end
