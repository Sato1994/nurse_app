# require 'rails_helper'

# RSpec.describe "Api::Agreements", type: :request do
#   let(:user) { agreement.user }
#   let(:agreement) { create(:agreement)}
#   let(:uid) { response.headers["uid"] }
#   let(:client) { response.headers["client"] }
#   let(:access_token) { response.headers["access-token"]}
#   before do
#     create_list(:agreement, 10)
#     post "/api/user/sign_in", params: { email: user.email, password: user.password }
#   end

#   describe "GET /index" do
#     it "関与しているstateが0の現在時刻より6時間以内のagreementは全削除される" do
#       expect(Agreement.count).to eq(1)
#       get "/api/agreements", headers: {uid: uid, client: client, "access-token": access_token}

#     end

#     it ""
#   end


  # context "申請中の場合" do
    #   it "勤務開始ちょうど6時間前でagreementが削除される"  do
    #     agreement = create(:agreement)
    #     start = agreement.start_time
    #     travel 20.hour
    #     expect(agreement).to_not be_truthy
        
    #   end
    #   it "勤務開始6時間1秒前ならば削除されない" do
    #     agreement = create(:agreement)
    #     start = agreement.start_time
    #     travel - 5.hour - 59.second
    #     expect(agreement).to_not be_valid
    #   end
    # end


    




# end
