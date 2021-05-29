require 'rails_helper'

RSpec.describe "Api::Skills", type: :request do
  describe "GET /index" do
    before do
      create_list(:skill, 10)
      get api_skills_path
    end

    it "ステータス200を返す" do
      expect(response.status).to eq(200)
    end

    it "アクセスした場合skillの数と同じだけjsonを返す" do
      json = JSON.parse(response.body)
      expect(json.count).to eq(Skill.count)
    end
  end

  describe "POST /create" do
    context "要素が有効な場合" do
      it "登録できる" do
        post "/api/skills", params: {skill: {name: "むぎ"}}
        expect(Skill.all.count). to eq(1)
      end
    end

    context "要素が無効な場合" do
      it "登録できない" do
        post "/api/skills", params: {skill: {name: " "}}
        expect(Skill.all.count). to eq(0)
      end
    end
  end

  describe "PUT /update" do
    context "要素が有効な場合" do
      it "更新される" do
        skill = create(:skill)
        put "/api/skills/#{skill.id}",params: {skill: {name: "もち"}}
        expect(skill.reload.name).to eq("もち")
      end
    end

    context "要素が無効な場合" do
      it "更新されない" do
        skill = create(:skill)
        put "/api/skills/#{skill.id}", params: {skill: {name: " "}}
        expect(skill.reload.name).to eq(skill.name)
      end
    end
  end

  describe "DELETE /destroy" do
    it "削除される" do
      skill = create(:skill)
      delete "/api/skills/#{skill.id}"
      expect(response.status).to eq(204) 
    end
  end

end