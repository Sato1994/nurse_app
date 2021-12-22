class Api::HostsController < ApplicationController
include Pagination

  def index

    ########## skillが被っていないhostのidの配列の作成 ##########
    name = params[:name]
    address = params[:address]
    user_skill_ids = params[:skillsId].map(&:to_i)
    wanted = params[:wanted]

    all_hosts = Host.includes(:host_skills)

    target_hosts_id = [] 

    all_hosts.each do  |host|
      skills = host.host_skills
      host_skill_ids = []
      
      skills.each do |skill|
      host_skill_ids.push(skill.skill_id)
      end

     host_skill_ids.push(user_skill_ids)
     host_skill_ids.flatten!
     mixed_skill_ids = host_skill_ids.uniq

     if mixed_skill_ids.length == host_skill_ids.length
      target_hosts_id.push(host.id)
     end

    end

    ########## host検索 ##########
    hosts = Kaminari.paginate_array(Host.all.name_like(name).address_like(address).wanted_true(wanted).id_include(target_hosts_id)).page(params[:page]).per(10)
    
    pagination = resources_with_pagination(hosts)
    @object = {
      users: hosts.as_json, kaminari: pagination
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