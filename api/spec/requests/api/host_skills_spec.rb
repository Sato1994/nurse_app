require 'rails_helper'

RSpec.describe "Api::HostSkills", type: :request do
  describe "GET /index" do
    let(:host) { create(:host) }
    let(:skill) { create(:skill)}
    let(:hs) { create(:host_skill)}
    let(:uid) { response.headers["uid"] }
    let(:client) { response.headers["client"] }
    let(:access_token) { response.headers["access-token"]}
    before do
      post "/api/host/sign_in", params: { email: host.email, password: host.password }
    end
  
    describe "POST /create" do
      it "ログインすれば登録できる" do
        post "/api/skills/#{skill.id}/host_skills", headers: {uid: uid, client: client, "access-token": access_token}
        expect(host.skills.count).to eq(1)
      end
    end
  
    describe "DELETE /destroy" do
      let(:host) { hs.host }
      let(:skill) { hs.skill }
      
      it "ログインすれば削除できる" do
        delete  "/api/host_skills/#{skill.id}", headers: {uid: uid, client: client, "access-token": access_token}
        expect(host.skills.count).to eq(0)
      end
    end
  end
end
