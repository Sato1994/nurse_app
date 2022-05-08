# frozen_string_literal: true

class Api::Host::SessionsController < DeviseTokenAuth::SessionsController
  def create
    field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first

    @resource = nil
    if field
      q_value = get_case_insensitive_field_from_resource_params(field)

      @resource = find_resource(field, q_value)
    end

    if @resource && valid_params?(field,
                                  q_value) && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
      valid_password = @resource.valid_password?(resource_params[:password])
      if (@resource.respond_to?(:valid_for_authentication?) && !@resource.valid_for_authentication? do
            valid_password
          end) || !valid_password
        return render_create_error_bad_credentials
      end

      create_and_assign_token

      sign_in(:user, @resource, store: false, bypass: false)

      render_host = {
        id: @resource.id, myid: @resource.myid, name: @resource.name, address: @resource.address, lat: @resource.lat, lng: @resource.lng,
        image: @resource.image, wanted: @resource.wanted, phone: @resource.phone, profile: @resource.profile,
        created_at: @resource.created_at, rate_count: @resource.rates.count, rate_average: @resource.star_average
      }

      render_agreements = @resource.agreements.in_progress.order(:start_time).as_json(
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

      render_rooms = @resource.rooms
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

      render_host_requests = @resource.host_requests.order(:start_time).as_json(
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

      render_host_notices = @resource.host_notices.order(created_at: :desc).as_json(
        only: %i[action checked created_at id source_id source_type],
        include: {
          source: {
            only: [],
            include: {
              user: {
                only: %i[name myid image]
              }
            }
          }
        }
      )

      render_host_notices.each do |notice|
        notice['source']['partner'] = notice['source'].delete('user')
        if notice['source_type'] === 'Agreement'
          notice['source']['room'] = { id: @resource.host_notices.find(notice['id']).source.room.id }
        end
      end

      render_recruitment_times = @resource.recruitment_times.order(:start_time).as_json(
        only: %i[id start_time finish_time]
      )

      render_user_requests = @resource.user_requests.order(:start_time).as_json(
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

      render_host_skills = @resource.skills.as_json(
        only: %i[id name]
      )

      render json: {
        info: render_host, agreements: render_agreements, rooms: render_rooms, requests: render_host_requests,
        times: render_recruitment_times, offers: render_user_requests, skills: render_host_skills, notices: render_host_notices
      }

    elsif @resource && !(!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
      if @resource.respond_to?(:locked_at) && @resource.locked_at
        render_create_error_account_locked
      else
        render_create_error_not_confirmed
      end
    else
      render_create_error_bad_credentials
    end
  end

  private

  def create_and_assign_token
    if @resource.respond_to?(:with_lock)
      @resource.with_lock do
        @token = @resource.create_token
        @resource.save!
      end
    else
      @token = @resource.create_token
      @resource.save!
    end
  end
end
