require 'rails_helper'

RSpec.describe Host, type: :model do
  
  describe "name" do
    it "なければ無効" do
      host = build(:host, name: nil)
      host.valid?
      expect(host.errors[:name]).to include("can't be blank")
    end

    it "40字を超える場合無効" do
      host = build(:host, name: "餅" * 41)
      host.valid?
      expect(host.errors[:name]).to include("is too long (maximum is 40 characters)")
    end
  end

  describe "email" do
    it "なければ無効" do
      host = build(:host, email: nil)
      host.valid?
      expect(host.errors[:email]).to include("can't be blank")
    end

    it "重複した場合無効" do
      host1 =create(:host)
      host2 = build(:host, email: host1.email)
      host2.valid?
      expect(host2.errors[:email]).to include("has already been taken")
    end
  end

  describe "myid" do
    it "なければ無効" do
      host = build(:host, myid: nil)
      host.valid?
      expect(host.errors[:myid]).to include("can't be blank")
    end

    it "15字を超える場合無効" do
      host = build(:host, myid: "a" * 16)
      host.valid?
      expect(host.errors[:myid]).to include("is too long (maximum is 15 characters)")
    end

    it "重複した場合無効" do
      host1 =create(:host)
      host2 = build(:host, myid: host1.myid)
      host2.valid?
      expect(host2.errors[:myid]).to include("has already been taken")
    end
  end

    
  
  it "passwordがなければ無効" do
    host = build(:host, password: nil)
    host.valid?
    expect(host.errors[:password]).to include("can't be blank")
  end
    

  it "nameとemailとpasswordとmyidがあれば有効" do
    host = build(:host)
    host.valid?
    expect(host).to be_valid
  end

  it "profileが300字を超える場合無効" do
    host = build(:host, profile: "餅" * 301)
    host.valid?
    expect(host.errors[:profile]).to include("is too long (maximum is 300 characters)")
  end

  it "すべてのオリジナルカラムが入力可能な状態" do
    host = build(:host, address: "mochimugi", image: "mochimugi", wanted: true, profile: "モチムギ" )
    host.valid?
    expect(host).to be_valid
  end
end