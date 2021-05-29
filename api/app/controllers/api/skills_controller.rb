class Api::SkillsController < ApplicationController

  # 認証していないと401エラーを返す
  # before_action :authenticate_api_user!, only: :create

  def index
    @skills = Skill.all
    render "index", formats: :json, handlers: :jbuilder
  end


  
  def create
    skill = Skill.new(skill_params)
    if skill.save
      render json: skill, status: 201
    else
      render json: skill.errors, status: 400
    end
  end

  

  def update
    skill = Skill.find(params[:id])
    if skill.update(skill_params)
      render json: skill, status: 200
    else
      render json: skill.errors, status: 400
    end
  end



  def destroy
    skill = Skill.find(params[:id])
    skill.destroy
  end

  private

  
  def skill_params
    params.require(:skill).permit(:name)
  end



end
