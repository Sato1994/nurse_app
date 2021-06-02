class Api::HostsController < ApplicationController
  def index
    @hosts = Host.all
    render "index", formats: :json, handlers: :jbuilder
  end

  def show
    @host = Host.find_by!(myid: params[:id])
    @skills = @host.skills
    render "show", formats: :json, handlers: :jbuilder
  end
end