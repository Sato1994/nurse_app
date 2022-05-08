# frozen_string_literal: true

class Api::User::SessionsController < DeviseTokenAuth::SessionsController
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

      render_user = @resource.as_json(
        only: %i[id myid name address lat lng image wanted sex age year profile created_at]
      )

      render_agreements = @resource.agreements.order(:start_time).in_progress.as_json(
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
      render_agreements.each do |agreement|
        agreement['partner'] = agreement.delete('host')
      end

      render_rooms = @resource.rooms
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

      render_user_requests = @resource.user_requests.order(:start_time).as_json(
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

      render_user_notices = @resource.user_notices.order(created_at: :desc).as_json(
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
          notice['source']['room'] = { id: @resource.user_notices.find(notice['id']).source.room.id }
        end
      end

      render_free_times = @resource.free_times.order(:start_time).as_json(
        only: %i[id start_time finish_time]
      )

      render_host_requests = @resource.host_requests.order(:start_time).as_json(
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

      render_user_skills = @resource.skills.as_json(
        only: %i[id name]
      )

      render json: {
        info: render_user, agreements: render_agreements, rooms: render_rooms, requests: render_user_requests,
        times: render_free_times, offers: render_host_requests, skills: render_user_skills, notices: render_user_notices
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
