# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::HostRequests', type: :request do
  let(:headers) do
    { uid: response.headers['uid'], client: response.headers['client'],
      'access-token': response.headers['access-token'] }
  end

  describe 'POST /create' do
    let(:host) { create(:host) }
    let(:free_time) { create(:free_time) }

    context 'リクエストが成功する場合' do
      before do
        post '/api/host/sign_in', params: { email: host.email, password: host.password }
        post "/api/host_requests/#{free_time.id}",
             params: { start_time: 21.hours.from_now, finish_time: 29.hours.from_now },
             headers: headers
      end

      it 'host_requestを作成できる' do
        expect(HostRequest.count).to eq(1)
      end

      it 'user_noticeが作成される' do
        expect(UserNotice.count).to eq(1)
      end

      it '必要なプロパティの数だけjsonを返す' do
        json = JSON.parse(response.body)
        expect(json.count).to eq(4)
      end

      it 'ステータス201を返す' do
        expect(response.status).to eq(201)
      end
    end

    context 'リクエストが失敗する場合' do
      before do
        post '/api/host/sign_in', params: { email: host.email, password: host.password }
        post "/api/host_requests/#{free_time.id}", params: { start_time: Time.current, finish_time: Time.current },
                                                   headers: headers
      end

      it 'ステータス400を返す' do
        expect(response.status).to eq(400)
      end

      it 'user_noticeは作成されない' do
        expect(UserNotice.count).to eq(0)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:host_request) { create(:host_request) }
    let!(:host_request_2) { create(:host_request) }

    context 'hostがログインしている場合' do
      it 'requestが本人の物の場合削除される' do
        free_time = host_request.free_time
        post '/api/host/sign_in', params: { email: host_request.host.email, password: host_request.host.password }
        expect do
          delete "/api/host_requests/#{host_request.id}",
                 headers: headers
        end.to change(HostRequest, :count).from(2).to(1)
      end

      it 'requestが他人の物の場合、失敗する' do
        free_time = host_request.free_time
        post '/api/host/sign_in', params: { email: host_request.host.email, password: host_request.host.password }
        expect do
          delete "/api/host_requests/#{host_request_2.id}",
                 headers: headers
        end.not_to change(HostRequest, :count)
      end
    end

    context 'userがログインしている場合' do
      it 'host_request.free_timeが本人の物の場合削除される' do
        free_time = host_request.free_time
        post '/api/user/sign_in', params: { email: free_time.user.email, password: free_time.user.password }
        expect do
          delete "/api/host_requests/#{host_request.id}",
                 headers: headers
        end.to change(HostRequest, :count).from(2).to(1)
      end

      it 'host_request.free_timeが他人の物の場合、失敗する' do
        free_time = host_request.free_time
        post '/api/user/sign_in', params: { email: free_time.user.email, password: free_time.user.password }
        expect do
          delete "/api/host_requests/#{host_request_2.id}",
                 headers: headers
        end.not_to change(HostRequest, :count)
      end
    end
  end
end
