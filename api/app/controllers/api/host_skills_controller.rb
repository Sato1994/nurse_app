# frozen_string_literal: true

class Api::HostSkillsController < ApplicationController
  before_action :authenticate_api_host!, only: [:destroy]
  
  def create
    skill = Skill.find(params[:skill_id])
    host_skill = current_api_host.host_skills.new(skill: skill)
    if host_skill.save
      render json: { id: skill.id, name: skill.name }
    else
      render json: host_skill.errors, status: :bad_request
    end
  end

  def destroy
    host_skill = HostSkill.find_by(host_id: current_api_host.id, skill_id: params[:id])
    skill = Skill.find(params[:id])
    if host_skill.destroy
      render json: skill, status: :ok
    else
      rende json: host_skill.errors, status: :bad_request
    end
  end
end
