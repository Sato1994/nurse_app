require 'rails_helper'

RSpec.describe "Api::Rooms", type: :request do
  let(:uid) { response.headers["uid"] }
  let(:client) { response.headers["client"] }
  let(:access_token) { response.headers["access-token"]}

  describe "GET /rooms" do
    
  end

  describe "POST /create" do
    let!(:free_time) { create(:free_time) }
    let!(:recruitment_time) { create(:recruitment_time) }
    let!(:user_request) { create(:user_request) }
    let!(:host_request) { create(:host_request) }

    context "userとしてログインしている場合" do
      before do
        post "/api/user/sign_in", params: { email: free_time.user.email, password: free_time.user.password}
      end

      it "roomを作成できる" do
        post "/api/rooms/host/#{host_request.host.id}", params: {start_time: host_request.start_time, finish_time: host_request.finish_time, request_id: host_request.id}, headers: {uid: uid, client: client, "access-token": access_token}
        expect(Room.count).to eq(1)
      end

      it "作成したら必要カラムだけのjsonを返す" do
        post "/api/rooms/host/#{host_request.host.id}", params: {start_time: host_request.start_time, finish_time: host_request.finish_time, request_id: host_request.id}, headers: {uid: uid, client: client, "access-token": access_token}
        json = JSON.parse(response.body)
        expect(json.count).to eq(9)
      end

      it "作成したらステータス201を返す" do
        post "/api/rooms/host/#{host_request.host.id}", params: {start_time: host_request.start_time, finish_time: host_request.finish_time, request_id: host_request.id}, headers: {uid: uid, client: client, "access-token": access_token}
        expect(response.status).to eq(201)
      end

      it "作成したらhost_requestが削除される" do
       expect{
         post "/api/rooms/host/#{host_request.host.id}",
         params: {start_time: host_request.start_time, finish_time: host_request.finish_time, request_id: host_request.id},
         headers: {uid: uid, client: client, "access-token": access_token}
        }.to change{ HostRequest.count }.by(-1)

      end
    end

    context "hostとしてログインしている場合" do
      before do
        post "/api/host/sign_in", params: { email: recruitment_time.host.email, password: recruitment_time.host.password}
      end

      it "roomを作成できる" do
        post "/api/rooms/user/#{user_request.user.id}", params: {start_time: user_request.start_time, finish_time: user_request.finish_time, request_id: user_request.id}, headers: {uid: uid, client: client, "access-token": access_token}
        expect(Room.count).to eq(1)
      end

      it "登録したら必要カラムだけのjsonを返す" do
        post "/api/rooms/user/#{user_request.user.id}", params: {start_time: user_request.start_time, finish_time: user_request.finish_time, request_id: user_request.id}, headers: {uid: uid, client: client, "access-token": access_token}
        json = JSON.parse(response.body)
        expect(json.count).to eq(9)
      end

      it "登録したらステータス201を返す" do
        post "/api/rooms/user/#{user_request.user.id}", params: {start_time: user_request.start_time, finish_time: user_request.finish_time, request_id: user_request.id}, headers: {uid: uid, client: client, "access-token": access_token}
        expect(response.status).to eq(201)
      end

      it "作成したらuser_requestが削除される" do
        expect{
          post "/api/rooms/user/#{user_request.user.id}",
          params: {start_time: user_request.start_time, finish_time: user_request.finish_time, request_id: user_request.id},
          headers: {uid: uid, client: client, "access-token": access_token}
         }.to change{ UserRequest.count }.by(-1)
 
       end

      
    end
    
    context "ログインしていない場合" do
      it "失敗する" do
        post "/api/rooms/host/#{host_request.user.id}", params: {start_time: host_request.start_time, finish_time: host_request.finish_time, request_id: host_request.id}
        expect(Room.count).to eq(0)
      end
      it "失敗する" do
        post "/api/rooms/user/#{user_request.user.id}", params: {start_time: user_request.start_time, finish_time: user_request.finish_time, request_id: user_request.id}
        expect(Room.count).to eq(0)
      end
    end

  end
end