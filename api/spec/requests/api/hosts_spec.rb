# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'api::hosts', type: :request do
  let(:json) { JSON.parse(response.body) }

  describe 'GET /index' do
    before do
      create_list(:host, 10)
      get '/api/hosts'
    end

    it 'ステータス200を返す' do
      expect(response.status).to eq(200)
    end

    it 'アクセスした場合2つのjsonを返す' do
      json = JSON.parse(response.body)
      expect(json.count).to eq(2)
    end
  end

  describe 'GET /show' do
    let(:host_skill) { create(:host_skill) }

    it 'responseには7つの配列が入る' do
      get "/api/hosts/#{host_skill.host.myid}"
      expect(json.count).to eq(7)
    end
  end
end
