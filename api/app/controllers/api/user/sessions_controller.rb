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

      render_user = @resource.render_user
      render_agreements = @resource.render_agreements
      render_rooms = @resource.render_rooms
      render_user_requests = @resource.render_user_requests
      render_user_notices = @resource.render_user_notices
      render_free_times = @resource.render_free_times
      render_host_requests = @resource.render_host_requests
      render_user_skills = @resource.render_user_skills

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
