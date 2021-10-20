class Api::HostsController < ApplicationController
  def index
    @hosts = Host.all
    render "index", formats: :json, handlers: :jbuilder
  end

  def show
    @host = Host.find_by!(myid: params[:id])
    if api_host_signed_in?
      if @host = current_api_host
        @requests = @host.host_requests
        @offers = @host.user_requests
        @agreements = @host.agreements
      end
    end
    @skills = @host.skills
    @recruitment_times = @host.recruitment_times
    render "show", formats: :json, handlers: :jbuilder
  end
end