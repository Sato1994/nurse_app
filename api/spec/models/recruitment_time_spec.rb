# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecruitmentTime, type: :model do
  describe 'host' do
    it 'なければ無効' do
      rt = build(:recruitment_time, host: nil)
      rt.valid?
      expect(rt.errors[:host]).to include("can't be blank")
    end
  end

  describe 'start_time' do
    it '作成時点で開始時間まで12時間以上あれば有効' do
      rt = build(:recruitment_time, start_time: 12.hours.from_now + 1)
      expect(rt).to be_valid
    end

    it '作成時点で開始時間までちょうど12時間前ならば期待するエラーメッセージを返す' do
      rt = build(:recruitment_time, start_time: 12.hours.from_now)
      rt.valid?
      expect(rt.errors[:message]).to include('登録時間は現在時刻より12時間以上時間の猶予が必要です。')
    end
  end

  describe 'start_time, finish_time' do
    context '登録時間' do
      it '１時間なら有効' do
        rt = build(:recruitment_time, finish_time: 21.hours.from_now)
        expect(rt).to be_valid
      end

      it '1時間未満なら期待するエラーメッセージを返す' do
        rt = build(:recruitment_time, finish_time: 21.hours.from_now - 1.second)
        rt.valid?
        expect(rt.errors[:message]).to include('登録時間は最低1時間以上です。')
      end
    end

    context '重複がある場合' do
      it '自分の持つ登録時間が重複すれば期待するエラーメッセージを返す' do
        rt = create(:recruitment_time)
        new_rt = build(:recruitment_time, host: rt.host)
        new_rt.valid?
        expect(new_rt.errors[:message]).to include('登録時間が重複しています。')
      end
    end
  end
end
