require 'rails_helper'

RSpec.describe "Api::HostMessages", type: :request do

  let(:uid) { response.headers["uid"] }
  let(:client) { response.headers["client"] }
  let(:access_token) { response.headers["access-token"] }
  
  describe "POST /create" do

    context "リクエストが成功する場合い" do
      before do
        room = create(:room)
        post "/api/host/sign_in", params: { email: room.host.email, password: room.host.password }
        post "/api/host_messages/#{room.id}", params: { message: "こんにちは" }, headers: { uid: uid, client: client, "access-token": access_token }
      end
      
      it "host_messageを作成できる" do
        expect(HostMessage.count).to eq(1)
      end

      it "プロパティの数だけjsonを返す" do
        json = JSON.parse(response.body)
        expect(json.count).to eq(5)
      end

      it "ステータス201を返す" do
        expect(response.status).to eq(201)
      end
    end

    context "リクエストが失敗する場合" do
      it "未認証ならばステータス401を返す" do
        room = create(:room)
        post "/api/host_messages/#{room.id}", params: { message: "こんにちは" }
        expect(response.status).to eq(401)
      end

      it "入力漏れならステータス400を返す" do
        room = create(:room)
        post "/api/host/sign_in", params: { email: room.host.email, password: room.host.password }
        post "/api/host_messages/#{room.id}", params: { message: "  " }, headers: { uid: uid, client: client, "access-token": access_token }
        expect(response.status).to eq(400)
      end


    end
  end
end
