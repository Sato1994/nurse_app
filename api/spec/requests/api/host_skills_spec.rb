# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::HostSkills', type: :request do
  describe 'GET /index' do
    let(:host) { create(:host) }
    let(:skill) { create(:skill) }
    let(:hs) { create(:host_skill) }
    let(:headers) do
      { uid: response.headers['uid'], client: response.headers['client'],
        'access-token': response.headers['access-token'] }
    end

    before do
      post '/api/host/sign_in', params: { email: host.email, password: host.password }
    end

    describe 'POST /create' do
      it 'ログインすれば登録できる' do
        post "/api/skills/#{skill.id}/host_skills", headers: headers
        expect(host.skills.count).to eq(1)
      end

      it '適切な数のjsonを返す' do
        post "/api/skills/#{skill.id}/host_skills", headers: headers
        json = JSON.parse(response.body)
        expect(json.count).to eq(2)
      end
    end

    describe 'DELETE /destroy' do
      let(:host) { hs.host }
      let(:skill) { hs.skill }

      it 'ログインしなければ削除できない' do
        delete "/api/host_skills/#{skill.id}"
        expect(host.skills.count).to eq(1)
      end

      it 'ログインすれば削除できる' do
        delete "/api/host_skills/#{skill.id}", headers: headers
        expect(host.skills.count).to eq(0)
      end

      it '適切な数のjsonを返す' do
        delete "/api/host_skills/#{skill.id}", headers: headers
        json = JSON.parse(response.body)
        expect(json.count).to eq(4)
      end
    end
  end
end
