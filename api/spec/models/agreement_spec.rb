# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agreement, type: :model do
  let!(:room) { create(:room) }

  describe 'user' do
    it 'なければ無効' do
      agreement = build(:agreement, room: room, user: nil)
      expect(agreement).to be_invalid
    end
  end

  describe 'host' do
    it 'なければ無効' do
      agreement = build(:agreement, room: room, host: nil)
      expect(agreement).to be_invalid
    end
  end

  describe 'room' do
    it '同じroom_idのものは無効' do
      agreement = create(:agreement)
      room = agreement.room
      new_agreement = build(:agreement, room: room)
      expect(new_agreement).to be_invalid
    end
  end

  describe 'start_time' do
    it '作成時点で勤務開始まで6時間以上あれば有効' do
      agreement = build(:agreement, room: room, start_time: 6.hours.from_now + 1.second,
                                    finish_time: 20.hours.from_now)
      expect(agreement).to be_valid
    end

    it '作成時点で勤務開始ちょうど6時間前ならば期待するエラーメッセージを返す' do
      agreement = build(:agreement, room: room, start_time: 6.hours.from_now)
      agreement.valid?
      expect(agreement.errors[:message]).to include('勤務開始時間は現在時刻より6時間以上の猶予が必要です。')
    end
  end

  describe 'start_time, finish_time' do
    it '同userで期間が重複している場合期待するエラーメッセージを返す' do
      create(:agreement, user: room.user)
      new_agreement = build(:agreement, room: room, user: room.user)
      new_agreement.valid?
      expect(new_agreement.errors[:message]).to include('看護師の勤務期間が他の契約と重複しています')
    end

    it 'ちょうど１時間なら有効' do
      agreement = build(:agreement, room: room, finish_time: 25.hours.from_now)
      expect(agreement).to be_valid
    end

    it '1時間未満なら期待するエラーメッセージを返す' do
      agreement = build(:agreement, room: room, finish_time: 25.hours.from_now - 1.second)
      agreement.valid?
      expect(agreement.errors[:message]).to include('勤務時間は1～18時間までです。')
    end

    it '18時間を超える場合期待するエラーメッセージを返す' do
      agreement = build(:agreement, room: room, finish_time: 42.hours.from_now + 1.second)
      agreement.valid?
      expect(agreement.errors[:message]).to include('勤務時間は1～18時間までです。')
    end
  end

  describe 'state' do
    it 'なければ無効' do
      agreement = build(:agreement, room: room, state: nil)
      expect(agreement).to be_invalid
    end
  end

  describe '全てのカラム' do
    it '全てあれば有効' do
      agreement = build(:agreement, room: room)
      expect(agreement).to be_valid
    end
  end

  describe 'methods' do
    context 'in_progress' do
      let(:agreement_1) { create(:agreement, state: 'before') }
      let(:agreement_2) { create(:agreement, state: 'during') }
      let(:agreement_3) { create(:agreement, state: 'finished') }
      let(:agreement_4) { create(:agreement, state: 'requesting') }
      let(:agreement_5) { create(:agreement, state: 'cancelled') }

      it 'stateがbefore, duringまたはrequestingのものが検索される' do
        expect(described_class.in_progress).to include(agreement_1, agreement_2, agreement_4)
      end

      it 'その他は検索されない' do
        expect(described_class.in_progress).not_to include(agreement_3, agreement_5)
      end
    end

    context 'not_in_progress' do
      let(:agreement_1) { create(:agreement, state: 'before') }
      let(:agreement_2) { create(:agreement, state: 'during') }
      let(:agreement_3) { create(:agreement, state: 'finished') }
      let(:agreement_4) { create(:agreement, state: 'requesting') }
      let(:agreement_5) { create(:agreement, state: 'cancelled') }

      it 'stateがfinishedまたはcancelledのものが検索される' do
        expect(described_class.not_in_progress).to include(agreement_3, agreement_5)
      end

      it 'その他は検索されない' do
        expect(described_class.not_in_progress).not_to include(agreement_1, agreement_2, agreement_4)
      end
    end

    context 'update_to_correct_state' do
      let(:now) { Time.current }

      it 'それぞれ適切なstateに変更される' do
        freeze_time
        # start_timeの境界線
        before_1 = create(:agreement, :skip_validate, state: 'before', start_time: now + 1.second, finish_time: now + 1.hour)
        before_2 = create(:agreement, :skip_validate, state: 'before', start_time: now, finish_time: now + 1.hour)
        # finish_timeの境界線
        before_3 = create(:agreement, :skip_validate, state: 'before', start_time: now.ago(1.hour), finish_time: now + 1.second)
        before_4 =  create(:agreement, :skip_validate, state: 'before', start_time: now.ago(1.hour), finish_time: now)

        during_1 =  create(:agreement, :skip_validate, state: 'during', start_time: now.ago(1.hour), finish_time: now + 1.second)
        during_2 = create(:agreement, :skip_validate, state: 'during', start_time: now.ago(1.hour), finish_time: now)

        requesting_1 = create(:agreement, :skip_validate, state: 'requesting', start_time: now + 6.hours + 1.second,
                                                          finish_time: now + 7.hours)
        requesting_2 = create(:agreement, :skip_validate, state: 'requesting', start_time: now + 6.hours,
                                                          finish_time: now + 7.hours)
        described_class.update_to_correct_state

        expect(before_1.reload.state).to eq('before')
        expect(before_2.reload.state).to eq('during')
        expect(before_3.reload.state).to eq('during')
        expect(before_4.reload.state).to eq('finished')

        expect(during_1.reload.state).to eq('during')
        expect(during_2.reload.state).to eq('finished')

        expect(requesting_1.reload.state).to eq('requesting')
        expect(requesting_2.reload.state).to eq('cancelled')
      end
    end
  end
end
