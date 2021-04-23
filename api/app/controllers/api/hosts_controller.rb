class Api::HostsController < ActionController::API
  def index
    @hosts = Host.all
    render "index", formats: :json, handlers: :jbuilder
  end
end