require 'rails_helper'

RSpec.describe User, type: :model do

  describe "name" do
    it "なければ無効" do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end

    it "20字を超える場合無効" do
      user = build(:user, name: "餅" * 21)
      user.valid?
      expect(user.errors[:name]).to include("is too long (maximum is 20 characters)")
    end
  end

  describe "email" do
    it "なければ無効" do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "重複した場合無効" do
      user1 = create(:user)
      user2 = build(:user, email: user1.email)
      user2.valid?
      expect(user2.errors[:email]).to include("has already been taken")
    end
  end

  describe "myid" do
    it "なければ無効" do
      user = build(:user, myid: nil)
      user.valid?
      expect(user.errors[:myid]).to include("can't be blank")
    end

    it "15字を超える場合無効" do
      user = build(:user, myid: "a" * 16)
      user.valid?
      expect(user.errors[:myid]).to include("is too long (maximum is 15 characters)")
    end

    it "重複した場合無効" do
      user1 =create(:user)
      user2 = build(:user, myid: user1.myid)
      user2.valid?
      expect(user2.errors[:myid]).to include("has already been taken")
    end
  end



  it "passwordがなければ無効" do
    user = build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end
    

  it "nameとemailとpasswordとmyidがあれば有効" do
    user = build(:user)
    user.valid?
    expect(user).to be_valid
  end

  it "profileが150字を超える場合無効" do
    user = build(:user, profile: "餅" * 151)
    user.valid?
    expect(user.errors[:profile]).to include("is too long (maximum is 150 characters)")
  end

  describe "age" do
    it "20未満の場合無効" do
      user = build(:user, age: 19)
      user.valid?
      expect(user.errors[:age]).to include("must be greater than or equal to 20")
    end

    it "60を超える場合無効" do
      user = build(:user, age: 61)
      user.valid?
      expect(user.errors[:age]).to include("must be less than or equal to 60")
    end
  end

  it "yearが40以上の場合無効" do
    user = build(:user, year: 40)
    user.valid?
    expect(user.errors[:year]).to include("must be less than 40")
  end

  it "すべてのオリジナルカラムが入力可能な状態" do
    user = build(:user, address: "mochimugi", image: "mochimugi", wanted: true, sex: true, age: 20, year: 20, profile: "モチムギ" )
    user.valid?
    expect(user).to be_valid
  end

end