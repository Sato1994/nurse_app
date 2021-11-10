require 'rails_helper'

RSpec.describe UserRequest, type: :model do
  describe "user" do
    it "なければ無効" do
      ur = build(:user_request, user: nil)
      expect(ur).to be_invalid
    end
  end

  describe "recruitment_time" do
    it "なければ無効" do
      ur = build(:user_request, recruitment_time: nil)
      expect(ur).to be_invalid
    end
  end

  describe "start_time, finish_time" do
    it "Recruitment_timeに申請時間の範囲が収まっている場合に成功" do
      rt = create(:recruitment_time)
      ur = build(:user_request, recruitment_time: rt)
      expect(ur).to be_valid
    end

    it "Recruitment_timeに申請時間の範囲が収まっていなければ失敗" do
      rt = create(:recruitment_time, start_time: Time.current + 25.hour)
      ur = build(:user_request, recruitment_time: rt)
      ur.valid?
      expect(ur.errors[:start_time]).to include("病院の募集時間の範囲を超えています。")
    end

    it "同じ時間帯のuser_requestがあれば失敗" do
      user_request = create(:user_request)
      new_request = build(:user_request, user: user_request.user)
      new_request.valid?
      expect(new_request.errors[:start_time]).to include("同じ時間帯で申請済みです。")
    end

    it "作成時点で開始時刻が7時間以上猶予があれば有効" do
      rt = create(:recruitment_time, start_time: Time.current + 13.hour, finish_time: Time.current + 23.hour)
      travel 6.hour - 1.second
      ur = build(:user_request, start_time: Time.current + 7.hour + 1.second, finish_time: Time.current + 10.hour, recruitment_time: rt )
      expect(ur).to be_valid

    end

    it "作成時点で開始時刻が7時間ちょうどなら無効" do
      rt = create(:recruitment_time, start_time: Time.current + 13.hour, finish_time: Time.current + 23.hour)
      travel 6.hour
      ur = build(:user_request, start_time: Time.current + 7.hour, finish_time: Time.current + 10.hour, recruitment_time: rt)
      ur.valid?
      expect(ur.errors[:start_time]).to include("申請時間は現時刻より7時間以上の猶予が必要です。")
    end

    it "登録時間が1時間以上なら有効" do
      rt = create(:recruitment_time)
      ur = build(:user_request, finish_time: Time.current + 22.hour, recruitment_time: rt)
      expect(ur).to be_valid
    end

    it "登録時間が1時間未満なら無効" do
      rt = create(:recruitment_time)
      ur = build(:user_request, finish_time: Time.current + 22.hour - 1.second, recruitment_time: rt)
      ur.valid?
      expect(ur.errors[:start_time]).to include("申請時間は最低1時間以上です。")
    end
  end
end