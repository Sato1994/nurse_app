# frozen_string_literal: true

class Api::UserSkillsController < ApplicationController
  before_action :authenticate_api_user!, only: [:destroy]

  def create
    skill = Skill.find(params[:skill_id])
    user_skill = current_api_user.user_skills.new(skill: skill)
    if user_skill.save
      render json: { id: skill.id, name: skill.name }
    else
      render json: user_skill.errors, status: :bad_request
    end
  end

  def destroy
    user_skill = UserSkill.find_by(user_id: current_api_user.id, skill_id: params[:id])
    skill = Skill.find(params[:id])
    if user_skill.destroy
      render json: skill, status: :ok
    else
      render json: user_skill.errors, status: :bad_request
    end
  end
end
