# frozen_string_literal: true

class Api::User::UsersController < ApplicationController
  include Pagination

  def index
    # host_skill_ids = []
    # current_api_host.host_skills.map { |skill| host_skill_ids.push(skill.skill_id) }

    # skillが被っていないuserのidの配列の作成

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

    all_users = all_users.order('RAND()').year_gt(params[:lowerYear]).address_like(params[:address]).wanted_true(params[:wanted]).id_include(
      target_users_id, params[:skillsId]
    ).as_json(
      only: %i[id myid image name profile wanted address]
    )

    render_users = Kaminari.paginate_array(all_users).page(params[:page]).per(10)

    render json: {
      partners: render_users, kaminari: resources_with_pagination(render_users)
    }
  end

  def show
    if api_user_signed_in? && current_api_user.myid == params[:id]

      user = User.includes([agreements: %i[room host],
                            rooms: :host,
                            user_requests: :host,
                            user_notices: [source: %i[host room]],
                            free_times: [host_requests: :host],
                            user_skills: :skill]).find(current_api_user.id)

      render_user = user.render_user
      render_agreements = user.render_agreements
      render_rooms = user.render_rooms
      render_user_requests = user.render_user_requests
      render_user_notices = user.render_user_notices
      render_free_times = user.render_free_times
      render_host_requests = user.render_host_requests
      render_user_skills = user.render_user_skills

      render json: {
        info: render_user, agreements: render_agreements, rooms: render_rooms, requests: render_user_requests,
        times: render_free_times, offers: render_host_requests, skills: render_user_skills, notices: render_user_notices
      }

    else
      user = User.includes([
                             free_times: [host_requests: :host],
                             user_skills: :skill
                           ]).find_by(myid: params[:id])

      render_free_times = user.render_free_times
      render_user_skills = user.render_user_skills
      render_user = user.render_user

      render json: {
        info: render_user, times: render_free_times, skills: render_user_skills
      }
    end
  end

  def history
    user = User.find_by(myid: params[:id])

    user = User.includes([
                           agreements: %i[room host rate cancell_comment]
                         ]).find_by(myid: params[:id])
    if api_user_signed_in? && current_api_user.myid == params[:id]

      render_agreements_list = user.agreements.order(start_time: 'DESC').not_in_progress.as_json(
        only: %i[start_time state],
        include: {
          room: {
            only: %i[id]
          },
          host: {
            only: %i[name myid]
          },
          rate: {
            only: %i[star]
          }
        }
      )

      render_cancell_comment = user.cancell_comments.count
      render_agreements_count = user.agreements.in_finished.count

      render_agreements_list.each do |agreement|
        agreement['partner'] = agreement.delete('host')
      end

      render json: {
        name: user.name,
        agreements_list: render_agreements_list,
        agreements_count: render_agreements_count,
        cancell_count: render_cancell_comment
      }

    else
      render_cancell_comment = user.cancell_comments.count
      render_agreements_count = user.agreements.in_finished.count

      render json: {
        name: user.name,
        cancell_count: render_cancell_comment,
        agreements_count: render_agreements_count
      }
    end
  end
end
