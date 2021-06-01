require 'rails_helper'

RSpec.describe HostSkill, type: :model do
  describe "host_id" do
    it "なければ無効" do
      hs = build(:host_skill, host_id: nil)
      hs.valid?
      expect(hs.errors[:host_id]).to include("can't be blank")
    end
  end

  describe "skill_id" do
    it "なければ無効" do
      hs = build(:host_skill, skill_id: nil)
      hs.valid?
      expect(hs.errors[:skill_id]).to include("can't be blank")
    end
  end

  describe "host_id,skill_id" do
    it "両方あれば有効" do
      hs = create(:host_skill)
      expect(hs).to be_valid
    end

    it "同じペアの重複は無効" do
      hs1 = create(:host_skill)
      hs2 = build(:host_skill, host_id: hs1.host_id, skill_id: hs1.skill_id)
      hs2.valid?
      expect(hs2).to_not be_valid
    end


  end

  describe "host_skillのリレーションについて" do
    let(:hs) { create(:host_skill) }

    context "hostが削除された場合" do
      before do
        hs.host.destroy
      end
      it "skillは削除されない" do
        expect(Skill.count).to eq(1)
      end
      it "host_skillが削除される" do
        expect(HostSkill.count).to eq(0)
      end
    end

    context "skillが削除された場合" do
      before do
        hs.skill.destroy
      end
      it "hostは削除されない" do
        expect(Host.count).to eq(1)
      end
      it "host_skillが削除される" do
        expect(HostSkill.count).to eq(0)
      end
    end

    context "host_skillが削除された場合" do
      before do
        hs.destroy
      end
      it "hostは削除されない" do
        expect(Host.count).to eq(1)
      end
      it "skillは削除されない" do
        expect(Skill.count).to eq(1)
      end
    end
  end
end
