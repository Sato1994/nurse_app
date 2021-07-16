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
    context "勤務時間" do
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
    context "同一userが含まれる勤務時間の重複" do
      it "既存のagreementのstateが4なら有効" do
        agreement = create(:agreement, state: 4)
        user = agreement.user
        new = build(:agreement, user: user)
        expect(new).to be_valid
      end
      it "既存のagreementのstateが4以外なら無効" do
        agreement = create(:agreement)
        user = agreement.user
        new = build(:agreement, user: user)
        new.valid?
        expect(new.errors[:start_time]).to include("勤務時間が他の勤務時間と重複しています。")
      end
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