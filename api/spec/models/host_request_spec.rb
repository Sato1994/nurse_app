# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HostRequest, type: :model do
  describe 'start_time, finish_time' do
    let!(:free_time) { create(:free_time) }

    context '重複チェック' do
      it 'Free_timeに申請時間の範囲が収まっている場合に成功' do
        host_request = build(:host_request, free_time: free_time)
        expect(host_request).to be_valid
      end

      it 'Free_timeに申請時間の範囲が収まっていなければ期待するエラーメッセージを返す' do
        free_time = create(:free_time, start_time: 25.hours.from_now)
        host_request = build(:host_request, free_time: free_time)
        host_request.valid?
        expect(host_request.errors[:message]).to include('お相手の募集時間の範囲から外れています。')
      end

      it '同userへ同じ時間帯のhost_requestがあれば期待するエラーメッセージを返す' do
        host_request = create(:host_request)
        new_request = build(:host_request, host: host_request.host, free_time: host_request.free_time)
        new_request.valid?
        expect(new_request.errors[:message]).to include('同じ時間帯で申請済みです。')
      end

      it '同userから同じ時間帯のuser_requestがあれば期待するエラーメッセージを返す' do
        user_request = create(:user_request)
        free_time = create(:free_time, user: user_request.user)
        host_request = build(:host_request, host: user_request.recruitment_time.host, free_time: free_time)
        host_request.valid?
        expect(host_request.errors[:message]).to include('同じ時間帯でお相手から申請が来ています。')
      end

      it '同userとの同じ期間帯のroomがあれば期待するエラーメッセージを返す' do
        room = create(:room)
        free_time = create(:free_time, user: room.user)
        host_request = build(:host_request, host: room.host, free_time: free_time)
        host_request.valid?
        expect(host_request.errors[:message]).to include('同じ時間帯でお相手と交渉中です。')
      end
    end

    context '期間制限チェック' do
      it '作成時点で開始時刻が8時間以上猶予があれば有効' do
        free_time = create(:free_time, start_time: 13.hours.from_now, finish_time: 23.hours.from_now)
        travel 6.hours - 1.second
        host_request = build(:host_request, start_time: 8.hours.from_now + 1.second,
                                            finish_time: 10.hours.from_now, free_time: free_time)
        expect(host_request).to be_valid
      end

      it '作成時点で開始時刻が現時刻から8時間ちょうどなら期待するエラーメッセージを返す' do
        free_time = create(:free_time, start_time: 13.hours.from_now, finish_time: 23.hours.from_now)
        travel 6.hours
        host_request = build(:host_request, start_time: 8.hours.from_now, finish_time: 10.hours.from_now,
                                            free_time: free_time)
        host_request.valid?
        expect(host_request.errors[:message]).to include('申請時間は現時刻より8時間以上の猶予が必要です。')
      end

      it '登録時間が1時間以上なら有効' do
        host_request = build(:host_request, finish_time: 22.hours.from_now, free_time: free_time)
        expect(host_request).to be_valid
      end

      it '登録時間が1時間未満なら期待するエラーメッセージを返す' do
        host_request = build(:host_request, finish_time: 22.hours.from_now - 1.second, free_time: free_time)
        host_request.valid?
        expect(host_request.errors[:message]).to include('申請時間は最低1時間以上です。')
      end
    end
  end
end
