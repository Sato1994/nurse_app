# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::FreeTimes', type: :request do
  let(:headers) do
    { uid: response.headers['uid'], client: response.headers['client'],
      'access-token': response.headers['access-token'] }
  end

  describe 'GET /index' do
    let(:free_time) { create(:free_time, :skip_validate, start_time: 8.hours.from_now) }
    let(:free_time_2) do
      create(:free_time, :skip_validate, user: free_time.user, start_time: 8.hours.from_now + 1.second)
    end
    let(:json) { JSON.parse(response.body) }

    before do
      get '/api/free_times', params: { user_id: free_time_2.user_id }
    end

    it '現在時刻からちょうど8時間なものだけ削除される' do
      expect(FreeTime.count).to eq(1)
    end

    it '期待した数のプロパティを返す' do
      expect(json.count).to eq(1)
    end
  end

  describe 'POST /create' do
    context 'リクエストが成功する場合' do
      let(:user) { create(:user) }

      before do
        post '/api/user/sign_in', params: { email: user.email, password: user.password }
        post '/api/free_times', params: { start_time: '2030-08-06T00:00:00', finish_time: '2030-08-06T08:00:00' },
                                headers: headers
      end

      it 'free_timeを作成できる' do
        expect(FreeTime.count).to eq(1)
      end

      it 'プロパティの数だけjsonを返す' do
        json = JSON.parse(response.body)
        expect(json.count).to eq(6)
      end

      it 'ステータス201を返す' do
        expect(response.status).to eq(201)
      end
    end

    context 'リクエストが失敗する場合' do
      let(:user) { create(:user) }

      it '失敗したらステータス400を返す' do
        post '/api/user/sign_in', params: { email: user.email, password: user.password }
        post '/api/free_times', params: { start_time: '2030-08-06T00:00:00', finish_time: '2030-08-06T00:00:00' },
                                headers: headers
        expect(response.status).to eq(400)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:free_time) { create(:free_time) }

    it '成功したら削除される' do
      post '/api/user/sign_in', params: { email: free_time.user.email, password: free_time.user.password }
      expect do
        delete "/api/free_times/#{free_time.id}", headers: headers
      end.to change(FreeTime, :count).from(1).to(0)
    end

    it '別ユーザーなら削除されない' do
      user_2 = create(:user)

      post '/api/user/sign_in', params: { email: user_2.email, password: user_2.password }
      expect do
        delete "/api/free_times/#{free_time.id}", headers: headers
      end.not_to change(FreeTime, :count).from(1)
    end
  end
end
