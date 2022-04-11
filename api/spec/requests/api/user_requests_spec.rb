# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::UserRequests', type: :request do
  let(:headers) do
    { uid: response.headers['uid'], client: response.headers['client'],
      'access-token': response.headers['access-token'] }
  end

  describe 'GET /index' do
    before do
      recruitment_time = create(:recruitment_time)
      recruitment_time_2 = create(:recruitment_time)
      user_request = create(:user_request, :skip_validate, start_time: 7.hours.from_now)
      user_request_2 = create(:user_request, :skip_validate, user: user_request.user, start_time: 7.hours.from_now + 1.second)
      get '/api/user_requests', params: { id: user_request_2.user_id }
    end

    let(:json) { JSON.parse(response.body) }

    it '現在時刻からちょうど8時間を超えるものだけ削除される' do
      expect(UserRequest.count).to eq(1)
    end

    it '期待した数のプロパティを返すこと' do
      expect(json.count).to eq(1)
    end
  end

  describe 'POST /create' do
    let(:user) { create(:user) }
    let(:recruitment_time) { create(:recruitment_time) }

    context 'リクエストが成功する場合' do
      before do
        post '/api/user/sign_in', params: { email: user.email, password: user.password }
        post "/api/user_requests/#{recruitment_time.id}",
             params: { start_time: 21.hours.from_now, finish_time: 29.hours.from_now },
             headers: headers
      end

      it 'user_requestを作成できる' do
        expect(UserRequest.count).to eq(1)
      end

      it 'host_noticeが作成される' do
        expect(HostNotice.count).to eq(1)
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
        post '/api/user/sign_in', params: { email: user.email, password: user.password }
        post "/api/user_requests/#{recruitment_time.id}",
             params: { start_time: Time.current, finish_time: Time.current },
             headers: headers
      end

      it 'ステータス400を返す' do
        expect(response.status).to eq(400)
      end

      it 'host_noticeは作成されない' do
        expect(HostNotice.count).to eq(0)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:user_request) { create(:user_request) }
    let!(:user_request_2) { create(:user_request) }

    context 'userがログインしている場合' do
      it 'requestが本人の物の場合削除される' do
        recruitment_time = user_request.recruitment_time
        post '/api/user/sign_in', params: { email: user_request.user.email, password: user_request.user.password }
        expect do
          delete "/api/user_requests/#{user_request.id}",
                 headers: headers
        end.to change(UserRequest, :count).from(2).to(1)
      end

      it 'requestが他人の物の場合、失敗する' do
        recruitment_time = user_request.recruitment_time
        post '/api/user/sign_in', params: { email: user_request.user.email, password: user_request.user.password }
        expect do
          delete "/api/user_requests/#{user_request_2.id}",
                 headers: headers
        end.not_to change(UserRequest, :count)
      end
    end

    context 'hostがログインしている場合' do
      it 'user_request.recruitment_timeが本人の物の場合削除される' do
        recruitment_time = user_request.recruitment_time
        post '/api/host/sign_in', params: { email: recruitment_time.host.email, password: recruitment_time.host.password }
        expect do
          delete "/api/user_requests/#{user_request.id}",
                 headers: headers
        end.to change(UserRequest, :count).from(2).to(1)
      end

      it 'user_request.recruitment_timeが他人の物の場合、失敗する' do
        recruitment_time = user_request.recruitment_time
        post '/api/host/sign_in', params: { email: recruitment_time.host.email, password: recruitment_time.host.password }
        expect do
          delete "/api/user_requests/#{user_request_2.id}",
                 headers: headers
        end.not_to change(UserRequest, :count)
      end
    end
  end

  #   describe "GET /index" do

  #########################################################
  #   context "stateが0の現在時刻より6時間以内のものは削除される" do
  #       before do
  #         create(:agreement)
  #       end
  #       let(:agreement) {create(:agreement)}

  #     it "userがログインしている場合" do
  #       user = agreement.user
  #       post "/api/user/sign_in", params: { email: user.email, password: user.password }
  #       travel 18.hour
  #       get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}
  #       travel 1.second
  #       expect{get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}}.to
  #       change{Agreement.count}.from(2).to(1)
  #     end

  #     it "userがログインしている場合" do
  #       user = agreement.user
  #       post "/api/user/sign_in", params: { email: user.email, password: user.password }
  #       travel 18.hour
  #       get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}
  #       travel 1.second
  #       expect{get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}}.to
  #       change{Agreement.count}.from(2).to(1)
  #     end
  #   end

  #   context "stateが1のものは勤務時間内であればstate2へ変更される" do
  #     it "userがログインしている場合" do
  #       create(:agreement, state: 1)
  #       agreement = create(:agreement, state: 1)
  #       user = agreement.user
  #       create(:agreement, user: user, start_time: Time.current + 33.hour, finish_time: Time.current + 41.hour)
  #       post "/api/user/sign_in", params: { email: user.email, password: user.password }
  #       travel 24.hour - 1.second
  #       get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}
  #       travel 1.second
  #       expect{get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}}.to
  #       change{Agreement.where(state: 2).count}.from(0).to(1)
  #     end

  #     it "userがログインしている場合" do
  #       create(:agreement, state: 1)
  #       agreement = create(:agreement, state: 1)
  #       user = agreement.user
  #       create(:agreement, user: user, start_time: Time.current + 33.hour, finish_time: Time.current + 41.hour)
  #       post "/api/user/sign_in", params: { email: user.email, password: user.password }
  #       travel 24.hour - 1.second
  #       get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}
  #       travel 1.second
  #       expect{get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}}.to
  #       change{Agreement.where(state: 2).count}.from(0).to(1)
  #     end
  #   end

  #   context "atateが1か2のものは勤務終了時間後であればstate3へ変更される" do
  #     before do
  #       create(:agreement, state: 1)
  #       create(:agreement, state: 2)
  #     end
  #     let(:agreement) { create(:agreement, state: 1)}

  #     it "userがログインしている場合" do
  #       user = agreement.user
  #       create(:agreement, state: 2, user: user, start_time: Time.current + 33.hour,
  #       finish_time: Time.current + 41.hour)
  #       post "/api/user/sign_in", params: { email: user.email, password: user.password }
  #       travel 41.hour
  #       get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}
  #       travel 1.second
  #       expect{get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}}.to
  #       change{Agreement.where(state: 3).count}.from(1).to(2)
  #     end

  #     it "userがログインしている場合" do
  #       user = agreement.user
  #       create(:agreement, state: 2, user: user, start_time: Time.current + 33.hour,
  #       finish_time: Time.current + 41.hour)
  #       post "/api/user/sign_in", params: { email: user.email, password: user.password }
  #       travel 41.hour
  #       get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}
  #       travel 1.second
  #       expect{get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}}.to
  #       change{Agreement.where(state: 3).count}.from(1).to(2)
  #     end
  #   end
  # end
  ###################################################################
end
