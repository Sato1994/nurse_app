require 'rails_helper'

RSpec.describe Agreement, type: :model do
  let!(:room) {create(:room)}
  
  describe "user" do
    it "なければ無効" do
      agreement = build(:agreement,room: room, user: nil)
      expect(agreement).to be_invalid
    end
  end

  describe "host" do
    it "なければ無効" do
      agreement = build(:agreement, room: room,  host: nil)
      expect(agreement).to be_invalid
    end
  end

  describe "room" do    
    it "同じroom_idのものは無効" do
      agreement = create(:agreement)
      room = agreement.room
      new_agreement = build(:agreement, room: room)
      expect(new_agreement).to be_invalid
    end
  end

  describe "start_time" do
    # it "作成時点で勤務開始まで6時間以上あれば有効" do
    #   agreement = build(:agreement, room: room, start_time: Time.current + 6.hour + 1.second, finish_time: Time.current + 20.hour)
    #   expect(agreement).to be_valid
    # end

    it "作成時点で勤務開始ちょうど6時間前ならば無効" do
      agreement = build(:agreement, room: room, start_time: Time.current + 6.hour)
      expect(agreement).to be_invalid
    end
  end

  describe "start_time, finish_time" do
    it "同userで期間が重複している場合無効" do
      agreement = create(:agreement, user: room.user)
      new_agreement = build(:agreement, room: room, user: room.user)
      expect(new_agreement).to be_invalid
    end

    # it "ちょうど１時間なら有効" do
    #   agreement = build(:agreement, room: room, finish_time: Time.current + 25.hour)
    #   expect(agreement).to be_valid
    # end

    it "1時間未満なら無効" do
      agreement = build(:agreement, room: room, finish_time: Time.current + 25.hour - 1.second )
      expect(agreement).to be_invalid

    end

    # it "18時間を超える場合無効" do
    #   agreement = build(:agreement, room: room, finish_time: Time.current + 42.hour + 1.second)
    #   expect(agreement).to be_invalid
    # end
  end

  describe "state" do
    it "なければ無効" do
      agreement = build(:agreement, room: room, state: nil)
      expect(agreement).to be_invalid
    end
  end

  describe "全てのカラム" do
    it "全てあれば有効" do
      agreement = build(:agreement, room: room)
      expect(agreement).to be_valid
    end
  end
end