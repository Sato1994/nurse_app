# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::RecruitmentTimes', type: :request do
  let(:headers) do
    { uid: response.headers['uid'], client: response.headers['client'],
      'access-token': response.headers['access-token'] }
  end

  describe 'GET /index' do
    let(:recruitment_time) { create(:recruitment_time, :skip_validate, start_time: 8.hours.from_now) }
    let(:recruitment_time_2) do
      create(:recruitment_time, :skip_validate, host: recruitment_time.host, start_time: 8.hours.from_now + 1.second)
    end
    let(:json) { JSON.parse(response.body) }

    before do
      get '/api/recruitment_times', params: { id: recruitment_time_2.host_id }
    end

    it '現在時刻からちょうど8時間を超えるのだけ削除される' do
      expect(RecruitmentTime.count).to eq(1)
    end

    it '期待した数のプロパティを返す' do
      expect(json.count).to eq(1)
    end
  end

  describe 'POST /create' do
    context 'リクエストが成功する場合' do
      let(:host) { create(:host) }

      before do
        post '/api/host/sign_in', params: { email: host.email, password: host.password }
        post '/api/recruitment_times', params: { start_time: '2030-08-06T00:00:00', finish_time: '2030-08-06T08:00:00' },
                                       headers: headers
      end

      it 'recruitment_timeを作成できる' do
        expect(RecruitmentTime.count).to eq(1)
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
      let(:host) { create(:host) }

      it '失敗したらステータス400を返す' do
        post '/api/host/sign_in', params: { email: host.email, password: host.password }
        post '/api/recruitment_times', params: { start_time: '2030-08-06T00:00:00', finish_time: '2030-08-06T00:00:00' },
                                       headers: headers
        expect(response.status).to eq(400)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:recruitment_time) { create(:recruitment_time) }

    it '成功したら削除される' do
      post '/api/host/sign_in', params: { email: recruitment_time.host.email, password: recruitment_time.host.password }
      expect do
        delete "/api/recruitment_times/#{recruitment_time.id}", headers: headers
      end.to change(RecruitmentTime, :count).from(1).to(0)
    end

    it '別hostなら削除されない' do
      host_2 = create(:host)

      post '/api/host/sign_in', params: { email: host_2.email, password: host_2.password }
      expect do
        delete "/api/recruitment_times/#{recruitment_time.id}", headers: headers
      end.not_to change(RecruitmentTime, :count).from(1)
    end
  end
end
