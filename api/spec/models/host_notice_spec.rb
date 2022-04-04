# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HostNotice, type: :model do
  describe 'action' do
    it 'なければ無効' do
      host_notice = build(:host_notice, action: nil)
      host_notice.valid?
      expect(host_notice.errors[:action]).to include("can't be blank")
    end

    it '指定した文字は有効' do
      array = %w[created left agreed changed cancelled]
      array.each do |i|
        host_notice = build(:host_notice, action: i)
        expect(host_notice).to be_valid
      end
    end

    it '指定した文字以外は無効' do
      host_notice = build(:host_notice, action: 'モチムギ')
      host_notice.valid?
      expect(host_notice.errors[:action]).to include('is not included in the list')
    end
  end

  describe 'checked' do
    it 'なければ無効' do
      host_notice = build(:host_notice, checked: nil)
      host_notice.valid?
      expect(host_notice.errors[:checked]).to include('is not included in the list')
    end
  end

  describe 'host' do
    it 'なければ無効' do
      host_notice = build(:host_notice, host: nil)
      host_notice.valid?
      expect(host_notice.errors[:host]).to include('must exist')
    end
  end

  describe 'source' do
    it 'なければ無効' do
      host_notice = build(:host_notice, source: nil)
      host_notice.valid?
      expect(host_notice.errors[:source]).to include("can't be blank")
    end
  end

  describe 'association(destroy)' do
    it 'user_requestは削除が連動する' do
      user_request = create(:user_request)
      host_notice = create(:host_notice, source: user_request)
      expect do
        user_request.destroy
      end.to change(described_class, :count).from(1).to(0)
    end

    it 'roomは削除が連動する' do
      room = create(:room)
      host_notice = create(:host_notice, source: room, host: room.host)
      expect do
        room.destroy
      end.to change(described_class, :count).from(1).to(0)
    end

    it 'rateは特に削除する機能は無し' do
      rate = create(:rate)
      host_notice = create(:host_notice, source: rate, host: rate.agreement.host)
      expect do
        rate.destroy
      end.not_to change(described_class, :count)
    end

    it 'agreementは特に削除する機能は無し' do
      agreement = create(:agreement)
      host_notice = create(:host_notice, source: agreement, host: agreement.host)
      expect do
        agreement.destroy
      end.not_to change(described_class, :count)
    end

    it 'hostは削除が連動する' do
      host_notice = create(:host_notice)
      expect do
        host_notice.host.destroy
      end.to change(described_class, :count).from(1).to(0)
    end
  end
end
