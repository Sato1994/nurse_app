require 'rails_helper'

RSpec.describe UserMessage, type: :model do
  describe "room" do
    it "なければ無効" do
      um = build(:user_message, room: nil)
      um.valid?
      expect(um.errors[:room]).to include("must exist")
    end
  end

  describe "message" do
    it "なければ無効" do
      um = build(:user_message, message: nil)
      um.valid?
      expect(um.errors[:message]).to include("can't be blank")
    end

    it "500文字なら有効" do
      um = build(:user_message, message: "あ" * 500)
      um.valid?
      expect(um).to be_valid
    end

    it "501文字なら無効" do
      um = build(:user_message, message: "あ" * 501)
      um.valid?
      expect(um.errors[:message]).to include("is too long (maximum is 500 characters)")
    end
  end

  describe "association" do
    let(:um) { create(:user_message) }
    it "roomが削除されれば削除される" do
      um.room.destroy
      expect(UserMessage.count).to eq(0)
      
    end
    
    it "userが削除されれば削除される" do
      um.room.user.destroy
      expect(UserMessage.count).to eq(0)
    end

    it "hostが削除されれば削除される" do
      um.room.host.destroy
      expect(UserMessage.count).to eq(0)
    end
  end
end
