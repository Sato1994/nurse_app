# frozen_string_literal: true

class Api::HostsController < ApplicationController
  include Pagination

  def index
    # skillが被っていないhostのidの配列の作成
    name = params[:name]
    address = params[:address]
    wanted = params[:wanted]

    user_skill_ids = []
    user_skill_ids.push(params[:skillsId].map(&:to_i)).flatten! if params[:skillsId].present?

    all_hosts = Host.includes(:host_skills)

    target_hosts_id = []

    all_hosts.each do |host|
      skills = host.host_skills
      host_skill_ids = []

      skills.each do |skill|
        host_skill_ids.push(skill.skill_id)
      end

      host_skill_ids.push(user_skill_ids)
      host_skill_ids.flatten!
      mixed_skill_ids = host_skill_ids.uniq

      target_hosts_id.push(host.id) if mixed_skill_ids.length == host_skill_ids.length
    end

    # host検索
    hosts = Kaminari.paginate_array(Host.all.name_like(name).address_like(address).wanted_true(wanted).id_include(
                                      target_hosts_id, params[:skillsId]
                                    )).page(params[:page]).per(10)

    pagination = resources_with_pagination(hosts)
    @object = {
      users: hosts.as_json, kaminari: pagination
    }
    render json: @object
  end

  def show
    if api_host_signed_in? && current_api_host.myid == params[:id]

      host = Host.includes([agreements: %i[room user],
                            rooms: :user,
                            host_requests: :user,
                            recruitment_times: [user_requests: :user],
                            host_skills: :skill]).find(current_api_host.id)

      render_host = host.as_json(
        only: %i[id myid name address lat lng image wanted phone profile created_at]
      )

      render_agreements = host.agreements.in_progress.as_json(
        only: %i[id start_time finish_time state],
        include: {
          room: {
            only: %i[id]
          },
          user: {
            only: %i[name myid]
          }
        }
      )

      # key変更
      render_agreements.each do |agreement|
        agreement['partner'] = agreement.delete('user')
      end

      render_rooms = host.rooms.display_room_for_host.as_json(
        only: %i[id state closed start_time finish_time created_at],
        include: {
          user: {
            only: %i[id name]
          }
        }
      )

      render_rooms.each do |room|
        room['partner'] = room.delete('user')
      end

      render_host_requests = host.host_requests.as_json(
        only: %i[id start_time finish_time],
        include: {
          user: {
            only: %i[id name image myid]
          }
        }
      )

      render_host_requests.each do |request|
        request['partner'] = request.delete('user')
      end

      render_recruitment_times = host.recruitment_times.as_json(
        only: %i[id start_time finish_time]
      )

      render_user_requests = host.user_requests.as_json(
        only: %i[id start_time finish_time],
        include: {
          user: {
            only: %i[id name image myid]
          }
        }
      )

      render_user_requests.each do |request|
        request['partner'] = request.delete('user')
      end

      render_host_skills = host.skills.as_json(
        only: %i[name]
      )

      render json: {
        info: render_host, agreements: render_agreements, rooms: render_rooms, requests: render_host_requests,
        times: render_recruitment_times, offers: render_user_requests, skills: render_host_skills
      }

    else
      host = Host.includes([
                             recruitment_times: [user_requests: :user],
                             host_skills: :skill
                           ]).find_by(myid: params[:id])

      render_recruitment_times = host.recruitment_times.as_json(
        only: %i[id start_time finish_time]
      )

      render_host_skills = host.skills.as_json(
        only: %i[name]
      )

      render_host = host.as_json(
        only: %i[id myid name address lat lng image wanted phone profile created_at]
      )

      render json: {
        info: render_host, times: render_recruitment_times, skills: render_host_skills
      }
    end
  end
end
