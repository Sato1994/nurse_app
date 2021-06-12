class Api::UserSkillsController < ApplicationController

  # before_action :authenticate_api_user!, only: [:create]

  def create
    skill = Skill.find(params[:skill_id])
    user_skill = current_api_user.user_skills.new(skill: skill, user: current_api_user)
    if user_skill.save
      render json: skill, status: :created
    else
      render json: user_skill.errors, status: :bad_request
    end
  end

  def destroy
    user_skill = UserSkill.find_by(user_id: current_api_user.id, skill_id: params[:id])
    skill = Skill.find(params[:id])
    if user_skill.user_id == current_api_user.id
      if user_skill.destroy
        render body: nil, status: :no_content
      else
        rende json: user_skill.errors, status: :bad_request
      end
    else
      render body: nil, status: :bad_request
    end

  end

end
