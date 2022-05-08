# frozen_string_literal: true

class Api::SkillsController < ApplicationController
  def index
    render_skills = Skill.all.as_json(
      only: %i[id name]
    )
    render json: {
      skills: render_skills
    }
  end
end
