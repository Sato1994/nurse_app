# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CancellComment, type: :model do
  describe 'agreement' do
    it 'なければ無効' do
      cc = build(:cancell_comment, agreement: nil)
      cc.valid?
      expect(cc.errors[:agreement]).to include('must exist')
    end

    it '同じagreementには作れない' do
      cc = create(:cancell_comment)
      cc_2 = build(:cancell_comment, agreement: cc.agreement)
      expect(cc_2).to be_invalid
    end
  end

  describe 'comment' do
    it 'なければ無効' do
      cc = build(:cancell_comment, comment: nil)
      cc.valid?
      expect(cc.errors[:comment]).to include("can't be blank")
    end

    it '50文字なら有効' do
      cc = build(:cancell_comment, comment: 'あ' * 50)
      expect(cc).to be_valid
    end

    it '51文字なら無効' do
      cc = build(:cancell_comment, comment: 'あ' * 51)
      cc.valid?
      expect(cc.errors[:comment]).to include('is too long (maximum is 50 characters)')
    end
  end
end
