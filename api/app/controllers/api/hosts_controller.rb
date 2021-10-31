class Api::HostsController < ApplicationController
  def index
    @hosts = Host.all
    render "index", formats: :json, handlers: :jbuilder
  end
end