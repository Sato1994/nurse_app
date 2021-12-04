require 'rails_helper'

RSpec.describe "Api::UserRequests", type: :request do
  let(:uid) { response.headers["uid"] }
  let(:client) { response.headers["client"] }
  let(:access_token) { response.headers["access-token"]}

  describe "POST /create" do
    let(:user) { create(:user) }
    let(:recruitment_time) { create(:recruitment_time) }

    context "リクエストが成功する場合" do
      before do
        post "/api/user/sign_in", params: { email: user.email, password: user.password }
        post "/api/user_requests/#{recruitment_time.id}", params: { start_time: Time.current + 21.hour, finish_time: Time.current + 29.hour }, headers: {uid: uid, client: client, "access-token": access_token}
      end
      it "user_requestを作成できる" do
        expect(UserRequest.count).to eq(1)
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
        post "/api/user/sign_in", params: { email: user.email, password: user.password }
        post "/api/user_requests/#{recruitment_time.id}", params: { start_time: Time.current, finish_time: Time.current }, headers: {uid: uid, client: client, "access-token": access_token}
        expect(response.status).to eq(400)
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
  #       expect{get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}}.to change{Agreement.count}.from(2).to(1)
  #     end

  #     it "userがログインしている場合" do
  #       user = agreement.user
  #       post "/api/user/sign_in", params: { email: user.email, password: user.password }
  #       travel 18.hour
  #       get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}
  #       travel 1.second
  #       expect{get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}}.to change{Agreement.count}.from(2).to(1)
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
  #       expect{get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}}.to change{Agreement.where(state: 2).count}.from(0).to(1)
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
  #       expect{get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}}.to change{Agreement.where(state: 2).count}.from(0).to(1)
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
  #       create(:agreement, state: 2, user: user, start_time: Time.current + 33.hour, finish_time: Time.current + 41.hour)
  #       post "/api/user/sign_in", params: { email: user.email, password: user.password }
  #       travel 41.hour
  #       get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}
  #       travel 1.second
  #       expect{get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}}.to change{Agreement.where(state: 3).count}.from(1).to(2)
  #     end

  #     it "userがログインしている場合" do
  #       user = agreement.user
  #       create(:agreement, state: 2, user: user, start_time: Time.current + 33.hour, finish_time: Time.current + 41.hour)
  #       post "/api/user/sign_in", params: { email: user.email, password: user.password }
  #       travel 41.hour
  #       get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}
  #       travel 1.second
  #       expect{get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}}.to change{Agreement.where(state: 3).count}.from(1).to(2)
  #     end
  #   end
  # end
  ###################################################################
end
