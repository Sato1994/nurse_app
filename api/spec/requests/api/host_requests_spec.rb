require 'rails_helper'

RSpec.describe "Api::HostRequests", type: :request do
  let(:uid) { response.headers["uid"] }
  let(:client) { response.headers["client"] }
  let(:access_token) { response.headers["access-token"]}

  describe "POST /create" do
    let(:host) { create(:host) }
    let(:free_time) { create(:free_time) }

    context "リクエストが成功する場合" do
      before do
        post "/api/host/sign_in", params: { email: host.email, password: host.password }
        post "/api/host_requests/#{free_time.id}", params: { start_time: Time.current + 21.hour, finish_time: Time.current + 29.hour }, headers: {uid: uid, client: client, "access-token": access_token}
      end
      it "host_requestを作成できる" do
        expect(HostRequest.count).to eq(1)
      end

      it "必要なプロパティの数だけjsonを返す" do
        json = JSON.parse(response.body)
        expect(json.count).to eq(4)
      end

      it "ステータス201を返す" do
        expect(response.status).to eq(201)
      end
    end

    context "リクエストが失敗する場合" do
      it "ステータス400を返す" do
        post "/api/host/sign_in", params: { email: host.email, password: host.password }
        post "/api/host_requests/#{free_time.id}", params: { start_time: Time.current, finish_time: Time.current }, headers: {uid: uid, client: client, "access-token": access_token}
        expect(response.status).to eq(400)
      end
    end

  end
end
