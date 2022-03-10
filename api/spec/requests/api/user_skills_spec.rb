# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::UserSkills', type: :request do
  let(:user) { create(:user) }
  let(:skill) { create(:skill) }
  let(:us) { create(:user_skill) }
  let(:headers) do
    { uid: response.headers['uid'], client: response.headers['client'],
      'access-token': response.headers['access-token'] }
  end

  before do
    post '/api/user/sign_in', params: { email: user.email, password: user.password }
  end

  describe 'POST /create' do
    it 'ログインすれば登録できる' do
      post "/api/skills/#{skill.id}/user_skills", headers: headers
      expect(user.skills.count).to eq(1)
    end

    it '適切な数のjsonを返す' do
      post "/api/skills/#{skill.id}/user_skills", headers: headers
      json = JSON.parse(response.body)
      expect(json.count).to eq(2)
    end
  end

  describe 'DELETE /destroy' do
    let(:user) { us.user }
    let(:skill) { us.skill }

    it 'ログインしなければ削除できない' do
      delete "/api/user_skills/#{skill.id}"
      expect(user.skills.count).to eq(1)
    end

    it 'ログインすれば削除できる' do
      delete "/api/user_skills/#{skill.id}", headers: headers
      expect(user.skills.count).to eq(0)
    end

    it '適切な数のjsonを返す' do
      delete "/api/user_skills/#{skill.id}", headers: headers
      json = JSON.parse(response.body)
      expect(json.count).to eq(4)
    end
  end
end
