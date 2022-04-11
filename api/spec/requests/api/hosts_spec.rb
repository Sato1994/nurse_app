# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'api::hosts', type: :request do
  let(:headers) do
    { uid: response.headers['uid'], client: response.headers['client'],
      'access-token': response.headers['access-token'] }
  end

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
    let(:host) { create(:host) }

    context '本人のページの場合' do
      it '期待する数のプロパティを返す' do
        post '/api/host/sign_in', params: { email: host.email, password: host.password }
        get "/api/hosts/#{host.myid}", {
          headers: headers
        }
        expect(json.count).to eq(7)
      end
    end

    context '他人のページの場合' do
      it '期待する数のプロパティを返す' do
        get "/api/hosts/#{host.myid}"
        expect(json.count).to eq(3)
      end
    end
  end
end
