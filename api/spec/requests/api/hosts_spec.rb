require 'rails_helper'

RSpec.describe "api::hosts", type: :request do
  let(:json) {JSON.parse(response.body)}
  describe "GET /index" do
    before do
      create_list(:host, 10)
      get "/api/hosts"
    end
    it "ステータス200を返す" do
      expect(response.status).to eq(200)
    end
    it "アクセスした場合ホスト数と同じだけjsonを返す" do
      json = JSON.parse(response.body)
      expect(json.count).to eq Host.count
    end
  end

  describe "GET /show" do
    let(:host_skill) {create(:host_skill)}
    it "responseには6つの配列が入る" do
      get "/api/hosts/#{host_skill.host.myid}"
      expect(json.count).to eq(6)
    end
  end
end
