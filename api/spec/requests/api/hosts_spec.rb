require 'rails_helper'

RSpec.describe "api::hosts", type: :request do
  describe "GET /index" do
    before do
      create_list(:host, 10)
      get api_hosts_path
    end

    it "ステータス200を返す" do
      expect(response.status).to eq(200)
    end

    it "アクセスした場合ホスト数と同じだけjsonを返す" do
      json = JSON.parse(response.body)
      expect(json.count).to eq Host.count
    end
  end
end
