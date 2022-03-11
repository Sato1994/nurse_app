# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSkill, type: :model do
  describe 'user_id' do
    it 'なければ無効' do
      us = build(:user_skill, user_id: nil)
      us.valid?
      expect(us.errors[:user_id]).to include("can't be blank")
    end
  end

  describe 'skill_id' do
    it 'なければ無効' do
      us = build(:user_skill, skill_id: nil)
      us.valid?
      expect(us.errors[:skill_id]).to include("can't be blank")
    end
  end

  describe 'user_id,skill_id' do
    it '両方あれば有効' do
      us = create(:user_skill)
      expect(us).to be_valid
    end

    it '同じペアの重複は無効' do
      us1 = create(:user_skill)
      us2 = build(:user_skill, user_id: us1.user_id, skill_id: us1.skill_id)
      us2.valid?
      expect(us2).not_to be_valid
    end
  end

  describe 'user_skillのリレーションについて' do
    let(:us) { create(:user_skill) }

    context 'userが削除された場合' do
      before do
        us.user.destroy
      end

      it 'skillは削除されない' do
        expect(Skill.count).to eq(1)
      end

      it 'user_skillが削除される' do
        expect(described_class.count).to eq(0)
      end
    end

    context 'skillが削除された場合' do
      before do
        us.skill.destroy
      end

      it 'userは削除されない' do
        expect(User.count).to eq(1)
      end

      it 'user_skillが削除される' do
        expect(described_class.count).to eq(0)
      end
    end

    context 'user_skillが削除された場合' do
      before do
        us.destroy
      end

      it 'userは削除されない' do
        expect(User.count).to eq(1)
      end

      it 'skillは削除されない' do
        expect(Skill.count).to eq(1)
      end
    end
  end
end
