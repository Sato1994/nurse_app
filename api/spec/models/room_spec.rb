# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  describe 'user' do
    it 'なければ無効' do
      room = build(:room, user: nil)
      room.valid?
      expect(room.errors[:user]).to include("can't be blank")
    end
  end

  describe 'host' do
    it 'なければ無効' do
      room = build(:room, host: nil)
      room.valid?
      expect(room.errors[:host]).to include("can't be blank")
    end
  end

  describe 'start_time, finish_time' do
    it '同user-host間で同じ時間帯のroomがあれば失敗' do
      room = create(:room)
      new_room = build(:room, user: room.user, host: room.host)
      new_room.valid?
      expect(new_room.errors[:start_time]).to include('同じお相手と同じ時間帯で交渉中です。')
    end

    it '作成時点で勤務開始まで7時間以上あれば有効' do
      room = build(:room, start_time: 7.hours.from_now + 1.second, finish_time: 20.hours.from_now)
      expect(room).to be_valid
    end

    it '作成時点で勤務開始ちょうど7時間前なら無効' do
      room = build(:room, start_time: 7.hours.from_now)
      room.valid?
      expect(room.errors[:start_time]).to include('申請時間は現時刻から7時間以上の猶予が必要です。')
    end

    context '勤務時間' do
      it '1時間なら有効' do
        room = build(:room, finish_time: 22.hours.from_now)
        expect(room).to be_valid
      end

      it '1時間未満なら無効' do
        room = build(:room, finish_time: 22.hours.from_now - 1.second)
        room.valid?
        expect(room.errors[:start_time]).to include('申請時間は最低1時間以上です。')
      end

      it '18時間ちょうどなら有効' do
        room = build(:room, finish_time: 39.hours.from_now)
        expect(room).to be_valid
      end

      it '18時間を超える場合無効' do
        room = build(:room, finish_time: 39.hours.from_now + 1.second)
        room.valid?
        expect(room.errors[:start_time]).to include('申請時間は最高18時間までです。')
      end
    end
  end

  describe 'association' do
    it 'userが削除されれば削除される' do
      room = create(:room)
      expect { room.user.destroy }.to change(described_class, :count).by(-1)
    end

    it 'hostが削除されれば削除される' do
      room = create(:room)
      expect { room.host.destroy }.to change(described_class, :count).by(-1)
    end

    it '削除してもuser,hostは削除されない' do
      room = create(:room)
      room.destroy
      expect(described_class.count).to eq(0)
      expect(User.count).to eq(1)
      expect(Host.count).to eq(1)
    end
  end
end
