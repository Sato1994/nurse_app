# frozen_string_literal: true

class Api::User::UsersController < ApplicationController
  include Pagination

  def index
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

    all_users = all_users.order('RAND()').year_gt(params[:lowerYear].to_i).address_like(params[:address]).wanted_true(params[:wanted]).id_include(
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

      render_user = user.as_json(
        only: %i[id myid name address lat lng image wanted sex age year profile created_at]
      )

      render_agreements = user.agreements.order(:start_time).in_progress.as_json(
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

      render_rooms = user.rooms
                         .user_have_not_exited
                         .related_agreement_is_not_in_progress
                         .order(:start_time)
                         .as_json(
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

      render_user_requests = user.user_requests.order(:start_time).as_json(
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

      render_user_notices = user.user_notices.order(created_at: :desc).as_json(
        only: %i[action checked created_at id source_id source_type],
        include: {
          source: {
            only: [],
            include: {
              host: {
                only: %i[name myid image]
              }
            }
          }
        }
      )

      render_user_notices.each do |notice|
        notice['source']['partner'] = notice['source'].delete('host')
        if notice['source_type'] === 'Agreement'
          notice['source']['room'] = { id: user.user_notices.find(notice['id']).source.room.id }
        end
      end

      render_free_times = user.free_times.order(:start_time).as_json(
        only: %i[id start_time finish_time]
      )

      render_host_requests = user.host_requests.order(:start_time).as_json(
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
        only: %i[id name]
      )

      render json: {
        info: render_user, agreements: render_agreements, rooms: render_rooms, requests: render_user_requests,
        times: render_free_times, offers: render_host_requests, skills: render_user_skills, notices: render_user_notices
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
