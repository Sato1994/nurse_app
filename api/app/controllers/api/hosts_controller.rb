class Api::HostsController < ApplicationController
include Pagination

  def index
    hosts = Kaminari.paginate_array(Host.all).page(params[:page]).per(10)
    @pagination = resources_with_pagination(hosts)
    @hosts = hosts.as_json
    @object = {
      users: @hosts, kaminari: @pagination
    }
    render json: @object
  end

  def show
    @host = Host.find_by!(myid: params[:id])
    if api_host_signed_in?
      if @host = current_api_host
        @requests = @host.host_requests
        @offers = @host.user_requests
        @agreements = @host.agreements
        @rooms = @host.rooms
      end
    end
    @skills = @host.skills
    @recruitment_times = @host.recruitment_times
    render "show", formats: :json, handlers: :jbuilder
  end
end