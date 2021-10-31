require 'rails_helper'

RSpec.describe HostMessage, type: :model do
  describe "room" do
    it "なければ無効" do
      hm = build(:host_message, room: nil)
      hm.valid?
      expect(hm.errors[:room]).to include("must exist")
    end
  end

  describe "message" do
    it "なければ無効" do
      hm = build(:host_message, message: nil)
      hm.valid?
      expect(hm.errors[:message]).to include("can't be blank")
    end

    it "500文字なら有効" do
      hm = build(:host_message, message: "あ" * 500)
      hm.valid?
      expect(hm).to be_valid
    end

    it "501文字なら無効" do
      hm = build(:host_message, message: "あ" * 501)
      hm.valid?
      expect(hm.errors[:message]).to include("is too long (maximum is 500 characters)")
    end
  end

  describe "association" do
    let(:hm) { create(:host_message) }
    it "roomが削除されれば削除される" do
      hm.room.destroy
      expect(HostMessage.count).to eq(0)
      
    end
    
    it "userが削除されれば削除される" do
      hm.room.user.destroy
      expect(HostMessage.count).to eq(0)
    end

    it "hostが削除されれば削除される" do
      hm.room.host.destroy
      expect(HostMessage.count).to eq(0)
    end
  end
end
