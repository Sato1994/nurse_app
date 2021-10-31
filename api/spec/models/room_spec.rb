require 'rails_helper'

RSpec.describe Room, type: :model do
  describe "user" do
    it "なければ無効 " do
      room = build(:room, user: nil)
      room.valid?
      expect(room.errors[:user]).to include("can't be blank")
    end
  end
  
  describe "host" do
    it "なければ無効 " do
      room = build(:room, host: nil)
      room.valid?
      expect(room.errors[:host]).to include("can't be blank")
    end
  end

  describe "association" do
    
    it "userが削除されれば削除される" do
      room = create(:room)
      expect{ room.user.destroy }.to change{ Room.count }.by(-1)
    end

    it "hostが削除されれば削除される" do
      room = create(:room)
      expect{ room.host.destroy }.to change{ Room.count }.by(-1)
    end
    
    it "削除してもuser,hostは削除されない" do
      room = create(:room)
      room.destroy
      expect(Room.count).to eq(0)
      expect(User.count).to eq(1)
      expect(Host.count).to eq(1)
    end
  end
end
