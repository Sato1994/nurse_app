require 'rails_helper'

RSpec.describe "Api::FreeTimes", type: :request do
  let(:uid) { response.headers["uid"] }
  let(:client) { response.headers["client"] }
  let(:access_token) { response.headers["access-token"]}



  # describe "GET /index" do
  #   it "" 
  # end




  

  describe "POST /create" do
    context "リクエストが成功する場合" do
      let(:user) { create(:user) }
      before do
        post "/api/user/sign_in", params: { email: user.email, password: user.password }
        post "/api/free_times", params: {start_time: "2030-08-06T00:00:00", finish_time: "2030-08-06T08:00:00"}, headers: {uid: uid, client: client, "access-token": access_token}
      end

      it "free_timeを作成できる" do
        expect(FreeTime.count).to eq(1)
      end
      
      it "プロパティの数だけjsonを返す" do
        json = JSON.parse(response.body)
        expect(json.count).to eq(6)
      end

      it "ステータス201を返す" do
        expect(response.status).to eq(201)
      end
    end

    context "リクエストが失敗する場合" do
      let(:user) { create(:user) }
      it "失敗したらステータス400を返す" do
        post "/api/user/sign_in", params: { email: user.email, password: user.password }
        post "/api/free_times", params: {start_time: "2030-08-06T00:00:00", finish_time: "2030-08-06T00:00:00"}, headers: {uid: uid, client: client, "access-token": access_token}
        expect(response.status).to eq(400)
      end
    end

    

  end
end
