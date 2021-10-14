class Api::HostSkillsController < ApplicationController

  def create
    skill = Skill.find(params[:skill_id])
    #どれでもOK
    # host_skill = current_api_host.host_skills.new(skill: skill, host: current_api_host)
    # host_skill = HostSkill.new(skill_id: skill.id, host_id: current_api_host.id)
    host_skill = current_api_host.host_skills.new(skill: skill)
    if host_skill.save
      render json: skill, status: :created
    else
      render json: host_skill.errors, status: :bad_request
    end
  end

  def destroy
    host_skill = HostSkill.find_by(host_id: current_api_host.id, skill_id: params[:id])
    skill = Skill.find(params[:id])
    if host_skill.host_id == current_api_host.id
      if host_skill.destroy
        render json: skill, status: 200
      else
        rende json: host_skill.errors, status: :bad_request
      end
    else
      render body: nil, status: :bad_request
    end

  end


end
