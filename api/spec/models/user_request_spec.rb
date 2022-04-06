# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserRequest, type: :model do
  describe 'start_time, finish_time' do
    let!(:recruitment_time) { create(:recruitment_time) }

    context '重複チェック' do
      it 'Recruitment_timeに申請時間の範囲が収まっている場合に成功' do
        user_request = build(:user_request, recruitment_time: recruitment_time)
        expect(user_request).to be_valid
      end

      it 'Recruitment_timeに申請時間の範囲が収まっていなければ期待するエラーメッセージを返す' do
        recruitment_time = create(:recruitment_time, start_time: 25.hours.from_now)
        user_request = build(:user_request, recruitment_time: recruitment_time)
        user_request.valid?
        expect(user_request.errors[:message]).to include('病院の募集時間の範囲を超えています。')
      end

      it '同じ時間帯のuser_requesがあれば期待するエラーメッセージを返す' do
        user_request = create(:user_request)
        new_request = build(:user_request, user: user_request.user, recruitment_time: recruitment_time)
        new_request.valid?
        expect(new_request.errors[:message]).to include('同じ時間帯で申請済みです。')
      end

      it '同じ時間帯のhost_requestがあれば期待するエラーメッセージを返す' do
        host_request = create(:host_request)
        recruitment_time = create(:recruitment_time, host: host_request.host)
        user_request = build(:user_request, user: host_request.free_time.user, recruitment_time: recruitment_time)
        user_request.valid?
        expect(user_request.errors[:message]).to include('同じ時間帯でお相手から申請が来ています。')
      end

      it '同じ時間帯のAgreementがあれば期待するエラーメッセージを返す' do
        agreement = create(:agreement)
        user_request = build(:user_request, user: agreement.user, recruitment_time: recruitment_time)
        user_request.valid?
        expect(user_request.errors[:message]).to include('同じ時間帯で契約済みです。')
      end

      it '同userとの同じ期間帯のroomがあれば期待するエラーメッセージを返す' do
        room = create(:room)
        recruitment_time = create(:recruitment_time, host: room.host)
        user_request = build(:user_request, user: room.user, recruitment_time: recruitment_time)
        user_request.valid?
        expect(user_request.errors[:message]).to include('同じ時間帯でお相手と交渉中です。')
      end
    end

    context '期間制限チェック' do
      it '作成時点で開始時刻が7時間以上猶予があれば有効' do
        recruitment_time = create(:recruitment_time, start_time: 13.hours.from_now,
                                                     finish_time: 23.hours.from_now)
        travel 6.hours - 1.second
        user_request = build(:user_request, start_time: 7.hours.from_now + 1.second,
                                            finish_time: 10.hours.from_now, recruitment_time: recruitment_time)
        expect(user_request).to be_valid
      end

      it '作成時点で開始時刻が7時間ちょうどなら期待するエラーメッセージを返す' do
        recruitment_time = create(:recruitment_time, start_time: 13.hours.from_now,
                                                     finish_time: 23.hours.from_now)
        travel 6.hours
        user_request = build(:user_request, start_time: 7.hours.from_now, finish_time: 10.hours.from_now,
                                            recruitment_time: recruitment_time)
        user_request.valid?
        expect(user_request.errors[:message]).to include('申請時間は現時刻より7時間以上の猶予が必要です。')
      end

      it '登録時間が1時間以上なら有効' do
        user_request = build(:user_request, finish_time: 22.hours.from_now, recruitment_time: recruitment_time)
        expect(user_request).to be_valid
      end

      it '登録時間が1時間未満なら期待するエラーメッセージを返す' do
        user_request = build(:user_request, finish_time: 22.hours.from_now - 1.second,
                                            recruitment_time: recruitment_time)
        user_request.valid?
        expect(user_request.errors[:message]).to include('申請時間は最低1時間以上です。')
      end
    end
  end
end
