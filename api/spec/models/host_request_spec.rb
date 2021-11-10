require 'rails_helper'

RSpec.describe HostRequest, type: :model do
  describe "host" do
    it "なければ無効" do
      hr = build(:host_request, host: nil)
      expect(hr).to be_invalid
    end
  end

  describe "free_time" do
    it "なければ無効" do
      hr = build(:host_request, free_time: nil)
      expect(hr).to be_invalid
    end
  end

  describe "start_time, finish_time" do
    
    it "Free_timeに申請時間の範囲が収まっている場合に成功" do
      ft = create(:free_time)
      hr = build(:host_request, free_time: ft)
      expect(hr).to be_valid
    end

    it "Free_timeに申請時間の範囲が収まっていなければ失敗" do
      ft = create(:free_time, start_time: Time.current + 25.hour)
      hr = build(:host_request, free_time: ft)
      hr.valid?
      expect(hr.errors[:start_time]).to include("お相手の募集時間の範囲から外れています。")
    end

    it "同userへ同じ時間帯のhost_requestがあれば失敗" do
      host_request = create(:host_request)
      new_request = build(:host_request, host: host_request.host, free_time: host_request.free_time)
      new_request.valid?
      expect(new_request.errors[:start_time]).to include("同じ時間帯で申請済みです。")
    end

    it "作成時点で開始時刻が7時間以上猶予があれば有効" do
      ft = create(:free_time, start_time: Time.current + 13.hour, finish_time: Time.current + 23.hour)
      travel 6.hour - 1.second
      hr = build(:host_request, start_time: Time.current + 7.hour + 1.second, finish_time: Time.current + 10.hour, free_time: ft )
      expect(hr).to be_valid

    end

    it "作成時点で開始時刻が現時刻から7時間ちょうどなら無効" do
      ft = create(:free_time, start_time: Time.current + 13.hour, finish_time: Time.current + 23.hour)
      travel 6.hour
      hr = build(:host_request, start_time: Time.current + 7.hour, finish_time: Time.current + 10.hour, free_time: ft )
      hr.valid?
      expect(hr.errors[:start_time]).to include("申請時間は現時刻より7時間以上の猶予が必要です。")
    end

    it "登録時間が1時間以上なら有効" do
      ft = create(:free_time)
      hr = build(:host_request, finish_time: Time.current + 22.hour, free_time: ft)
      expect(hr).to be_valid
    end

    it "登録時間が1時間未満なら無効" do
      ft = create(:free_time)
      hr = build(:host_request, finish_time: Time.current + 22.hour - 1.second, free_time: ft)
      hr.valid?
      expect(hr.errors[:start_time]).to include("申請時間は最低1時間以上です。")
    end
  end
end
