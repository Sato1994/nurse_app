require 'rails_helper'

RSpec.describe "Api::UserSkills", type: :request do
  let(:user) { create(:user) }
  let(:skill) { create(:skill)}
  let(:us) { create(:user_skill)}
  let(:uid) { response.headers["uid"] }
  let(:client) { response.headers["client"] }
  let(:access_token) { response.headers["access-token"]}
  before do
    post "/api/user/sign_in", params: { email: user.email, password: user.password }
  end

  describe "POST /create" do
    it "ログインすれば登録できる" do
      post "/api/skills/#{skill.id}/user_skills", headers: {uid: uid, client: client, "access-token": access_token}
      expect(user.skills.count).to eq(1)
    end
  end

  describe "DELETE /destroy" do
    let(:user) { us.user }
    let(:skill) { us.skill }
    
    it "ログインすれば削除できる" do
      delete  "/api/user_skills/#{skill.id}", headers: {uid: uid, client: client, "access-token": access_token}
      expect(user.skills.count).to eq(0)
    end
  end
end
