# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Host::Hosts', type: :request do
  let(:headers) do
    { uid: response.headers['uid'], client: response.headers['client'],
      'access-token': response.headers['access-token'] }
  end

  let(:json) { JSON.parse(response.body) }

  describe 'GET /index' do
    context 'params[:sortedBy]がdistance' do
      context 'userとしてログイン' do
        before do
          create_list(:host, 10)
          user = create(:user)
          post '/api/user/sign_in', params: { email: user.email, password: user.password }
        end

        it 'ステータス200を返す' do
          get '/api/hosts', params: { sortBy: 'distance' }, headers: headers
          expect(response.status).to eq(200)
        end

        it 'アクセスした場合2つのjsonを返す' do
          get '/api/hosts', params: { sortBy: 'distance' }, headers: headers
          expect(json.count).to eq(2)
        end

        it 'プロパティpartnersは期待した数のプロパティを返す' do
          get '/api/hosts', params: { sortBy: 'distance' }, headers: headers
          expect(json['partners'][0].count).to eq(8)
        end

        it 'パラメーターにdistanceがない場合期待した数のプロパティを返す' do
          get '/api/hosts', headers: headers
          expect(json['partners'][0].count).to eq(7)
        end
      end

      context 'userとしてログインしていない' do
        before do
          create_list(:host, 10)
          host = create(:host)
          post '/api/host/sign_in', params: { email: host.email, password: host.password }
        end

        it 'ステータス200を返す' do
          get '/api/hosts', params: { sortBy: 'distance' }, headers: headers
          expect(response.status).to eq(200)
        end

        it 'アクセスした場合2つのjsonを返す' do
          get '/api/hosts', params: { sortBy: 'distance' }, headers: headers
          expect(json.count).to eq(2)
        end

        it 'プロパティpartnersは期待した数のプロパティを返す' do
          get '/api/hosts', params: { sortBy: 'distance' }, headers: headers
          expect(json['partners'][0].count).to eq(7)
        end
      end
    end

    context 'params[:sortedBy]がrate' do
      context 'userとしてログイン' do
        before do
          create_list(:host, 10)
          user = create(:user)
          post '/api/user/sign_in', params: { email: user.email, password: user.password }
        end

        it 'ステータス200を返す' do
          get '/api/hosts', params: { sortBy: 'rate' }, headers: headers
          expect(response.status).to eq(200)
        end

        it 'アクセスした場合2つのjsonを返す' do
          get '/api/hosts', params: { sortBy: 'rate' }, headers: headers
          expect(json.count).to eq(2)
        end

        it 'プロパティpartnersは期待した数のプロパティを返す' do
          get '/api/hosts', params: { sortBy: 'rate' }, headers: headers
          expect(json['partners'][0].count).to eq(9)
        end

        it 'パラメーターにrateがない場合期待した数のプロパティを返す' do
          get '/api/hosts', headers: headers
          expect(json['partners'][0].count).to eq(7)
        end
      end

      context 'userとしてログインしていない' do
        before do
          create_list(:host, 10)
          host = create(:host)
          post '/api/host/sign_in', params: { email: host.email, password: host.password }
        end

        it 'ステータス200を返す' do
          get '/api/hosts', params: { sortBy: 'rate' }, headers: headers
          expect(response.status).to eq(200)
        end

        it 'アクセスした場合2つのjsonを返す' do
          get '/api/hosts', params: { sortBy: 'rate' }, headers: headers
          expect(json.count).to eq(2)
        end

        it 'プロパティpartnersは期待した数のプロパティを返す' do
          get '/api/hosts', params: { sortBy: 'rate' }, headers: headers
          expect(json['partners'][0].count).to eq(7)
        end
      end
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

  describe 'GET /history' do
    let(:host) {create(:host)}

    context '本人のページの場合' do
      it '期待する数のプロパティを返す' do
        post '/api/host/sign_in', params: { email: host.email, password: host.password }
        get "/api/hosts/#{host.myid}/history", { headers: headers }
        expect(json.count).to eq(3)
      end
    end

    context '他人のページの場合' do
      it '期待する数のプロパティを返す' do
        post '/api/host/sign_in', params: { email: host.email, password: host.password }
        get "/api/hosts/#{host.myid}/history"
        expect(json.count).to eq(2)
      end
    end
  end
end
