# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rate, type: :model do
  describe 'star' do
    it 'なければ無効' do
      rate = build(:rate, star: nil)
      rate.valid?
      expect(rate.errors[:star]).to include("can't be blank")
    end

    it '境界線チェック(0,1 & 5,6)' do
      rate_0 = build(:rate, star: 0)
      rate_1 = build(:rate, star: 1)
      rate_5 = build(:rate, star: 5)
      rate_6 = build(:rate, star: 6)
      rate_0.valid?
      rate_1.valid?
      rate_5.valid?
      rate_6.valid?
      expect(rate_0.errors[:star]).to include('must be greater than or equal to 1')
      expect(rate_1).to be_valid
      expect(rate_5).to be_valid
      expect(rate_6.errors[:star]).to include('must be less than or equal to 5')
    end

    it '小数点は無効' do
      rate = build(:rate, star: 3.5)
      rate.valid?
      expect(rate.errors[:star]).to include('must be an integer')
    end
  end

  describe 'comment' do
    it 'なければ無効' do
      rate = build(:rate, comment: nil)
      rate.valid?
      expect(rate.errors[:comment]).to include("can't be blank")
    end

    it '境界線チェック(0,1 & 300, 301)' do
      rate_0 = build(:rate, comment: '　')
      rate_1 = build(:rate, comment: 'あ')
      rate_300 = build(:rate, comment: 'あ' * 300)
      rate_301 = build(:rate, comment: 'あ' * 301)
      rate_0.valid?
      rate_1.valid?
      rate_300.valid?
      rate_301.valid?
      expect(rate_0.errors[:comment]).to include("can't be blank")
      expect(rate_1).to be_valid
      expect(rate_300).to be_valid
      expect(rate_301.errors[:comment]).to include('is too long (maximum is 300 characters)')
    end
  end

  describe 'agreement' do
    it 'なければ無効' do
      rate = build(:rate, agreement: nil)
      rate.valid?
      expect(rate.errors[:agreement]).to include("must exist")
    end

    it '同じagreementには作れない' do
      rate = create(:rate)
      rate_2 = build(:rate, agreement: rate.agreement)
      expect(rate_2).to be_invalid
    end
  end
end
