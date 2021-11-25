require 'rails_helper'

RSpec.describe Agreement, type: :model do
  describe "user" do
    it "なければ無効" do
      agreement = build(:agreement, user: nil)
      agreement.valid?
      expect(agreement.errors[:user]).to include("can't be blank")
    end
  end

  describe "host" do
    it "なければ無効" do
      agreement = build(:agreement, host: nil)
      agreement.valid?
      expect(agreement.errors[:host]).to include("can't be blank")
    end
  end

  describe "room" do
    it "なければ無効" do
      agreement = build(:agreement, room: nil)
      agreement.valid?
      expect(agreement.errors[:room]).to include("can't be blank")
    end
    
    it "同じroom_idのものは無効" do
      agreement = create(:agreement)
      room = agreement.room
      new_agreement = build(:agreement, room: room)
      expect(new_agreement).to be_invalid
    end
  end

  describe "start_time" do
    it "作成時点で勤務開始まで6時間以上あれば有効" do
      agreement = build(:agreement, start_time: Time.current + 6.hour + 1.second, finish_time: Time.current + 20.hour)
      expect(agreement).to be_valid
    end

    it "作成時点で勤務開始ちょうど6時間前ならば無効" do
      agreement = build(:agreement, start_time: Time.current + 6.hour)
      agreement.valid?
      expect(agreement.errors[:start_time]).to include("勤務開始時間は現在時刻より6時間以上の猶予が必要です。")
    end
  end

  describe "start_time, finish_time" do
    it "同userで期間が重複している場合無効" do
      agreement = create(:agreement)
      new_agreement = build(:agreement, user: agreement.user)
      new_agreement.valid?
      expect(new_agreement.errors[:start_time]).to include("看護師の勤務期間が他の契約と重複しています。")
    end

    it "１時間なら有効" do
      agreement = build(:agreement, finish_time: Time.current + 25.hour)
      expect(agreement).to be_valid
    end

    it "1時間未満なら無効" do
      agreement = build(:agreement, finish_time: Time.current + 25.hour - 1.second )
      agreement.valid?
      expect(agreement.errors[:finish_time]).to include("勤務時間は1～18時間までです。")
    end

    it "18時間を超える場合無効" do
      agreement = build(:agreement, finish_time: Time.current + 42.hour + 1.second)
      agreement.valid?
      expect(agreement.errors[:finish_time]).to include("勤務時間は1～18時間までです。")
    end
  end

  describe "state" do
    it "なければ無効" do
      agreement = build(:agreement, state: nil)
      agreement.valid?
      expect(agreement.errors[:state]).to include("is not included in the list")
    end
  end

  describe "全てのカラム" do
    it "全てあれば有効" do
      agreement = build(:agreement)
      expect(agreement).to be_valid
    end
  end
end