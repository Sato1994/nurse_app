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
    it '同user-host間で同じ時間帯のroomがあれば期待するエラーメッセージを返す' do
      room = create(:room)
      new_room = build(:room, user: room.user, host: room.host)
      new_room.valid?
      expect(new_room.errors[:message]).to include('同じお相手と同じ時間帯で交渉中です。')
    end

    it '作成時点で勤務開始まで7時間以上あれば有効' do
      room = build(:room, start_time: 7.hours.from_now + 1.second, finish_time: 20.hours.from_now)
      expect(room).to be_valid
    end

    it '作成時点で勤務開始ちょうど7時間前なら期待するエラーメッセージを返す' do
      room = build(:room, start_time: 7.hours.from_now)
      room.valid?
      expect(room.errors[:message]).to include('申請時間は現時刻から7時間以上の猶予が必要です。')
    end

    context '勤務時間' do
      it '1時間なら有効' do
        room = build(:room, finish_time: 22.hours.from_now)
        expect(room).to be_valid
      end

      it '1時間未満なら期待するエラーメッセージを返す' do
        room = build(:room, finish_time: 22.hours.from_now - 1.second)
        room.valid?
        expect(room.errors[:message]).to include('申請時間は最低1時間以上です。')
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

  describe 'methods' do
    let(:room_1) { create(:room, closed: 'na') }
    let(:room_2) { create(:room, closed: 'user') }
    let(:room_3) { create(:room, closed: 'host') }

    context 'display_room_for_user' do
      it 'closedがnaまたはhostのものが検索される' do
        expect(described_class.display_room_for_user).to include(room_1, room_3)
      end

      it 'その他は検索されない' do
        expect(described_class.display_room_for_user).not_to include(room_2)
      end
    end

    context 'display_room_for_host' do
      it 'closedがnaまたはuserのものが検索される' do
        expect(described_class.display_room_for_host).to include(room_1, room_2)
      end

      it 'その他は検索されない' do
        expect(described_class.display_room_for_host).not_to include(room_3)
      end
    end
  end
end
