require 'rails_helper'

RSpec.describe "Api::Rooms", type: :request do
  let(:uid) { response.headers["uid"] }
  let(:client) { response.headers["client"] }
  let(:access_token) { response.headers["access-token"]}

  describe "GET /rooms" do
    
  end

  describe "POST /create" do
    let(:user) { create(:user) }
    let(:host) { create(:host) }

    context "userとしてログインしている場合" do
      before do
        post "/api/user/sign_in", params: { email: user.email, password: user.password}
      end

      it "roomを作成できる" do
        post "/api/rooms/host/#{host.id}", headers: {uid: uid, client: client, "access-token": access_token}
        expect(Room.count).to eq(1)
      end

      it "登録したらjsonを返す" do
        post "/api/rooms/host/#{host.id}", headers: {uid: uid, client: client, "access-token": access_token}
        json = JSON.parse(response.body)
        expect(json.count).to eq(5)
      end

      it "登録したらステータス201を返す" do
        post "/api/rooms/host/#{host.id}", headers: {uid: uid, client: client, "access-token": access_token}
        expect(response.status).to eq(201)
      end
    end

    context "hostとしてログインしている場合" do
      before do
        post "/api/host/sign_in", params: { email: host.email, password: host.password}
      end

      it "roomを作成できる" do
        post "/api/rooms/user/#{user.id}", headers: {uid: uid, client: client, "access-token": access_token}
        expect(Room.count).to eq(1)
      end

      it "登録したらjsonを返す" do
        post "/api/rooms/user/#{user.id}",  headers: {uid: uid, client: client, "access-token": access_token}
        json = JSON.parse(response.body)
        expect(json.count).to eq(5)
      end

      it "登録したらステータス201を返す" do
        post "/api/rooms/user/#{user.id}",  headers: {uid: uid, client: client, "access-token": access_token}
        expect(response.status).to eq(201)
      end

      
    end
    
    context "ログインしていない場合" do
      it "失敗する" do
        post "/api/rooms/user/#{user.id}"
        expect(Room.count).to eq(0)
      end
      it "失敗する" do
        post "/api/rooms/host/#{host.id}"
        expect(Room.count).to eq(0)
      end
    end

  end
end