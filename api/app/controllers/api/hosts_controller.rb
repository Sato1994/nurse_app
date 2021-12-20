class Api::HostsController < ApplicationController
include Pagination

  def index
    name = params[:name]
    address = params[:address]
    if params[:wanted].blank?
      hosts = Kaminari.paginate_array(Host.where('name LIKE ? && address LIKE ?', "%#{name}%", "%#{address}%")).page(params[:page]).per(10)
    else
      hosts = Kaminari.paginate_array(Host.where('name LIKE ? && address LIKE ? && wanted = true', "%#{name}%", "%#{address}%")).page(params[:page]).per(10)
    end
    @pagination = resources_with_pagination(hosts)
    @hosts = hosts.as_json
    @object = {
      users: @hosts, kaminari: @pagination
    }
    render json: @object
  end

  def show
    if api_host_signed_in? && current_api_host.myid = params[:id]
      @host = current_api_host
      @requests = current_api_host.host_requests
      @offers = current_api_host.user_requests
      @agreements = current_api_host.agreements
      @rooms = current_api_host.rooms
      @skills = current_api_host.skills
      @recruitment_times = current_api_host.recruitment_times
    else
      @host = Host.find_by!(myid: params[:id])
      @recruitment_times = @host.recruitment_times
      @skills = @host.skills
    end
    render "show", formats: :json, handlers: :jbuilder
  end
end