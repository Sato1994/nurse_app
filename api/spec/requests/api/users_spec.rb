require 'rails_helper'

RSpec.describe "Api::Users", type: :request do
  let(:json) {JSON.parse(response.body)}

  describe "GET /index" do
    before do
      create_list(:user, 10)
      get "/api/users"
    end
    it "ステータス200を返す" do
      expect(response.status).to eq(200)
    end
    it "アクセスした場合ユーザー数と同じだけjsonを返す" do
      expect(json.count).to eq User.count
    end
  end
  
  describe "GET /show" do
    let(:user_skill) {create(:user_skill)}
    it "responseには6つの配列が入る" do
      get "/api/users/#{user_skill.user.myid}"
      expect(json.count).to eq(6)
    end
  end
end
