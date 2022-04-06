# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserNotice, type: :model do
  describe 'action' do
    it 'なければ無効' do
      user_notice = build(:user_notice, action: nil)
      user_notice.valid?
      expect(user_notice.errors[:action]).to include("can't be blank")
    end

    it '指定した文字は有効' do
      array = %w[created left agreed changed cancelled]
      array.each do |i|
        user_notice = build(:user_notice, action: i)
        expect(user_notice).to be_valid
      end
    end

    it '指定した文字以外は無効' do
      user_notice = build(:user_notice, action: 'モチムギ')
      user_notice.valid?
      expect(user_notice.errors[:action]).to include('is not included in the list')
    end
  end

  describe 'checked' do
    it 'なければ無効' do
      user_notice = build(:user_notice, checked: nil)
      user_notice.valid?
      expect(user_notice.errors[:checked]).to include('is not included in the list')
    end
  end

  describe 'user' do
    it 'なければ無効' do
      user_notice = build(:user_notice, user: nil)
      user_notice.valid?
      expect(user_notice.errors[:user]).to include('must exist')
    end
  end

  describe 'source' do
    it 'なければ無効' do
      user_notice = build(:user_notice, source: nil)
      user_notice.valid?
      expect(user_notice.errors[:source]).to include("can't be blank")
    end
  end

  describe 'association(destroy)' do
    it 'host_requestは削除が連動する' do
      host_request = create(:host_request)
      user_notice = create(:user_notice, source: host_request)
      expect do
        host_request.destroy
      end.to change(described_class, :count).from(1).to(0)
    end

    it 'roomは削除が連動する' do
      room = create(:room)
      user_notice = create(:user_notice, source: room, user: room.user)
      expect do
        room.destroy
      end.to change(described_class, :count).from(1).to(0)
    end

    it 'agreementは特に削除する機能は無し' do
      agreement = create(:agreement)
      user_notice = create(:user_notice, source: agreement, user: agreement.user)
      expect do
        agreement.destroy
      end.not_to change(described_class, :count)
    end

    it 'userは削除が連動する' do
      user_notice = create(:user_notice)
      expect do
        user_notice.user.destroy
      end.to change(described_class, :count).from(1).to(0)
    end
  end
end
