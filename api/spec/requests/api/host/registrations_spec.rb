# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'host登録', type: :request do
  describe 'POST /api/host' do
    it '有効な値を入力した場合ユーザ登録できる' do
      post '/api/host', params: attributes_for(:host)
      expect(response.status).to eq(200)
    end
  end

  describe 'POST /api/host/sign_in' do
    let(:host) { create(:host) }

    it 'email,passwordでログインできるか' do
      login
      expect(response.status).to eq(200)
    end
  end

  describe 'PUT /api/host' do
    let(:headers) do
      { uid: response.headers['uid'], client: response.headers['client'],
        'access-token': response.headers['access-token'] }
    end

    let(:host) { create(:host) }

    xit 'addressを入力していればlat, lngも登録される' do
      login
      put '/api/host', params: { address: '東京都港区芝公園' }, headers: headers
      expect(host.reload.lat).not_to be_nil
      expect(host.reload.lng).not_to be_nil
    end

    xit 'addressを入力していなければlat,lngは登録されない' do
      login
      put '/api/host', params: { name: 'もちむぎ' }, headers: headers
      expect(host.reload.lat).to be_nil
      expect(host.reload.lng).to be_nil
    end
  end

  describe 'DELETE /api/host/sign_out' do
    let(:host) { create(:host) }

    it 'uid,client,access-tokenを送信するとログアウトできる' do
      login
      delete '/api/host/sign_out', headers: {
        uid: response.headers['uid'],
        client: response.headers['client'],
        'access-token': response.headers['access-token']
      }
      expect(response.status).to eq(200)
    end

    it 'headersがない場合ログアウトできない' do
      login
      delete '/api/host/sign_out'
      expect(response.status).to eq(404)
    end
  end

  def login
    post '/api/host/sign_in', params: { email: host.email, password: host.password }
  end
end
