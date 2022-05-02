# frozen_string_literal: true

class Api::Host::HostsController < ApplicationController
  include Pagination

  def index
    # skillが被っていないhostのidの配列の作成
    user_skill_ids = []
    user_skill_ids.push(params[:skillsId].map(&:to_i)).flatten! if params[:skillsId].present?

    all_hosts = Host.includes(:host_skills, [agreements: :rate])

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
    if api_user_signed_in? && params[:sortBy] === 'distance'
      # 距離順
      all_hosts = all_hosts.name_like(params[:name]).address_like(params[:address]).wanted_true(params[:wanted]).id_include(
        target_hosts_id, params[:skillsId]
      )
      all_hosts = calc_distance(all_hosts)

      sorted_hosts = all_hosts.sort_by { |host| host[:distance] }

      sorted_hosts = sorted_hosts.as_json(
        only: %i[id myid image name profile wanted distance address]
      )

      render_hosts = Kaminari.paginate_array(sorted_hosts).page(params[:page]).per(10)

    elsif params[:sortBy] === 'rate'
      # 評価順
      all_hosts = all_hosts.name_like(params[:name]).address_like(params[:address]).wanted_true(params[:wanted]).id_include(
        target_hosts_id, params[:skillsId]
      )
      all_hosts = rate_average(all_hosts)

      sorted_hosts = all_hosts.sort_by { |host| -host[:rate_average] }

      sorted_hosts = sorted_hosts.as_json(
        only: %i[id myid image name profile wanted address rate_average rate_count]
      )

      render_hosts = Kaminari.paginate_array(sorted_hosts).page(params[:page]).per(10)

    else
      all_hosts = all_hosts.order('RAND()').name_like(params[:name]).address_like(params[:address]).wanted_true(params[:wanted]).id_include(
        target_hosts_id, params[:skillsId]
      ).as_json(
        only: %i[id myid image name profile wanted address]
      )
      render_hosts = Kaminari.paginate_array(all_hosts).page(params[:page]).per(10)

    end
    render json: {
      partners: render_hosts, kaminari: resources_with_pagination(render_hosts)
    }
  end

  def show
    if api_host_signed_in? && current_api_host.myid == params[:id]

      host = Host.includes([agreements: %i[room user],
                            rooms: :user,
                            host_requests: :user,
                            recruitment_times: [user_requests: :user],
                            host_skills: :skill]).find(current_api_host.id)

      render_host = {
        id: host.id, myid: host.myid, name: host.name, address: host.address, lat: host.lat, lng: host.lng,
        image: host.image, wanted: host.wanted, phone: host.phone, profile: host.profile,
        created_at: host.created_at, rate_count: host.rates.count, rate_average: host.star_average
      }

      render_agreements = host.agreements.in_progress.order(:start_time).as_json(
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

      render_rooms = host.rooms
                         .host_have_not_exited
                         .related_agreement_is_not_in_progress
                         .order(:start_time)
                         .as_json(
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

      render_host_requests = host.host_requests.order(:start_time).as_json(
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

      render_recruitment_times = host.recruitment_times.order(:start_time).as_json(
        only: %i[id start_time finish_time]
      )

      render_user_requests = host.user_requests.order(:start_time).as_json(
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
        only: %i[id name]
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

      render_host = {
        id: host.id, myid: host.myid, name: host.name, address: host.address, lat: host.lat, lng: host.lng,
        image: host.image, wanted: host.wanted, phone: host.phone, profile: host.profile,
        created_at: host.created_at, rate_count: host.rates.count, rate_average: host.star_average
      }

      render json: {
        info: render_host, times: render_recruitment_times, skills: render_host_skills
      }
    end
  end

  def history
    host = Host.find_by(myid: params[:id])

    host = Host.includes([
                           agreements: %i[room user]
                         ]).find_by(myid: params[:id])
    if api_host_signed_in? && current_api_host.myid == params[:id]

      render_agreements_list = host.agreements.order(start_time: 'DESC').not_in_progress.as_json(
        only: %i[start_time state],
        include: {
          room: {
            only: %i[id]
          },
          user: {
            only: %i[name myid]
          }
        }
      )

      render_agreements_count = host.agreements.in_finished.count

      render_agreements_list.each do |agreement|
        agreement['partner'] = agreement.delete('user')
      end

      render json: {
        name: host.name,
        agreements_list: render_agreements_list,
        agreements_count: render_agreements_count
      }

    else
      render_agreements_count = host.agreements.in_finished.count

      render json: {
        name: host.name,
        agreements_count: render_agreements_count
      }
    end
  end
end
