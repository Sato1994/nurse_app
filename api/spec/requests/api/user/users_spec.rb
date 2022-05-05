# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::User::Users', type: :request do
  let(:headers) do
    { uid: response.headers['uid'], client: response.headers['client'],
      'access-token': response.headers['access-token'] }
  end

  let(:json) { JSON.parse(response.body) }

  describe 'GET /index' do
    before do
      create_list(:user, 10)
      get '/api/users'
    end

    it 'ステータス200を返す' do
      expect(response.status).to eq(200)
    end

    it 'アクセスした場合2つのjsonを返す' do
      expect(json.count).to eq(2)
    end
  end

  describe 'GET /show' do
    let(:user) { create(:user) }

    context '本人のページの場合' do
      it '期待する数のプロパティを返す' do
        post '/api/user/sign_in', params: { email: user.email, password: user.password }
        get "/api/users/#{user.myid}", {
          headers: headers
        }
        expect(json.count).to eq(8)
      end
    end

    context '他人のページの場合' do
      it '期待する数のプロパティを返す' do
        get "/api/users/#{user.myid}"
        expect(json.count).to eq(3)
      end
    end
  end

  describe 'GET /history' do
    let(:user) {create(:user)}

    context '本人のページの場合' do
      it '期待する数のプロパティを返す' do
        post '/api/user/sign_in', params: { email: user.email, password: user.password }
        get "/api/users/#{user.myid}/history", { headers: headers }
        expect(json.count).to eq(4)
      end
    end

    context '他人のページの場合' do
      it '期待する数のプロパティを返す' do
        post '/api/user/sign_in', params: { email: user.email, password: user.password }
        get "/api/users/#{user.myid}/history"
        expect(json.count).to eq(3)
      end
    end
  end
end
