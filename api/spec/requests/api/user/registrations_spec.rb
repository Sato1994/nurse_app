# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'user登録', type: :request do
  describe 'POST /api/user' do
    it '有効な値を入力した場合ユーザ登録できる' do
      # attributes_for(:***)値をハッシュで生成する
      post '/api/user', params: attributes_for(:user)
      expect(response.status).to eq(200)
    end
  end

  describe 'POST /api/user/sign_in' do
    let(:user) { create(:user) }

    it 'email,passwordでログインできるか' do
      login
      expect(response.status).to eq(200)
    end
  end

  describe 'PUT /api/user' do
    let(:headers) do
      { uid: response.headers['uid'], client: response.headers['client'],
        'access-token': response.headers['access-token'] }
    end

    let(:user) { create(:user) }
    it "addressを入力していればlat, lngも登録される" do
      login
      put '/api/user', params: {address: "東京都港区芝公園" }, headers: headers
      expect(user.reload.lat).not_to be_nil
      expect(user.reload.lng).not_to be_nil
    end

    it 'addressを入力していなければlat,lngは登録されない' do
      login
      put '/api/user', params: { name: "もちむぎ" }, headers: headers
      expect(user.reload.lat).to be_nil
      expect(user.reload.lng).to be_nil
    end
  end

  describe 'DELETE /api/user/sign_out' do
    let(:user) { create(:user) }

    it 'uid,client,access-tokenを送信するとログアウトできる' do
      login
      delete '/api/user/sign_out', headers: {
        uid: response.headers['uid'],
        client: response.headers['client'],
        'access-token': response.headers['access-token']
      }
      expect(response.status).to eq(200)
    end

    it 'headersがない場合ログアウトできない' do
      login
      delete '/api/user/sign_out'
      expect(response.status).to eq(404)
    end
  end

  def login
    post '/api/user/sign_in', params: { email: user.email, password: user.password }
  end
end
