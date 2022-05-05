# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Skills', type: :request do
  describe 'GET /index' do
    before do
      create_list(:skill, 10)
      get api_skills_path
    end

    it 'ステータス200を返す' do
      expect(response.status).to eq(200)
    end

    it 'アクセスした場合skillの数と同じだけjsonを返す' do
      json = JSON.parse(response.body)
      expect(json['skills'].count).to eq(Skill.count)
    end
  end
end
