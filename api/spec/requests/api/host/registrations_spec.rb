# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'host登録', type: :request do
  let(:headers) do
    { uid: response.headers['uid'], client: response.headers['client'],
      'access-token': response.headers['access-token'] }
  end

  let(:json) { JSON.parse(response.body) }

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
      delete '/api/host/sign_out', headers: headers
      expect(response.status).to eq(200)
    end

    it 'headersがない場合ログアウトできない' do
      login
      delete '/api/host/sign_out'
      expect(response.status).to eq(404)
    end
  end

  describe 'DELETE /api/host' do
    let(:host) { create(:host) }

    describe '有効なrooms,またはagreementsがある場合' do
      before do
        login
        create(:agreement, host: host)
      end

      it 'status400(bad_request)を返す' do
        delete '/api/host', headers: headers
        expect(response.status).to eq(400)
      end

      it '期待するエラーメッセージを返す' do
        delete '/api/host', headers: headers
        expect(json['message'][0]).to eq('有効な交渉、または契約が存在するため退会できません。')
      end
    end

    describe '有効なrooms,またはagreementsがない場合' do
      before do
        login
      end

      it 'status200(ok)を返す' do
        delete '/api/host', headers: headers
        expect(response.status).to eq(200)
      end
    end
  end

  def login
    post '/api/host/sign_in', params: { email: host.email, password: host.password }
  end
end
