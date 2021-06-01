require 'rails_helper'

RSpec.describe Skill, type: :model do
  describe "name" do
    it "なければ無効" do
      skill = build(:skill, name: nil)
      skill.valid?
      expect(skill.errors[:name]).to include("can't be blank")
    end

    it "30字を超える場合無効" do
      skill = build(:skill, name: "a" * 31)
      skill.valid?
      expect(skill.errors[:name]).to include("is too long (maximum is 30 characters)")
    end

    it "重複した場合無効" do
      skill1 =create(:skill)
      skill2 = build(:skill, name: skill1.name)
      skill2.valid?
      expect(skill2.errors[:name]).to include("has already been taken")
    end
  end

  it "すべてのオリジナルカラムが入力可能な状態" do
    skill = build(:skill, name: "モチムギ" )
    skill.valid?
    expect(skill).to be_valid
  end
  
end
