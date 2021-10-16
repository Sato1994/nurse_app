class Api::HostsController < ApplicationController
  def index
    @hosts = Host.all
    render "index", formats: :json, handlers: :jbuilder
  end

  def show
    @host = Host.find_by!(myid: params[:id])
    @skills = @host.skills

    @recruitment_times = @host.recruitment_times
    render "show", formats: :json, handlers: :jbuilder
  end
end