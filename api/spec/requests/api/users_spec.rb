require 'rails_helper'

RSpec.describe "Api::Users", type: :request do
  describe "GET /index" do
    before do
      create_list(:user, 10)
      get api_users_path
    end

    it "ステータス200を返す" do
      expect(response.status).to eq(200)
    end

    it "アクセスした場合ユーザー数と同じだけjsonを返す" do
      json = JSON.parse(response.body)
      expect(json.count).to eq User.count
    end
  end
end
