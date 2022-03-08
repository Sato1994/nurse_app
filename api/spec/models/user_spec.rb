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

  it "profileが300字を超える場合無効" do
    user = build(:user, profile: "餅" * 301)
    user.valid?
    expect(user.errors[:profile]).to include("is too long (maximum is 300 characters)")
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

  ########## メソッド ##########
  describe "year_gt" do
    let!(:user_1) { create(:user, year: 0) }
    let!(:user_2) { create(:user, year: 1) }
    let!(:user_3) { create(:user, year: 2) }
    it "引数の数以上のyearを持つuserが検索される" do
      expect(User.year_gt(1)).to include(user_2, user_3)
    end

    it "引数の数未満のyearを持つuserは検索されない" do
      expect(User.year_gt(1)).to_not include(user_1)
    end
  end

  describe "address_like" do
    let!(:user_1) { create(:user, address: "東京都江戸川区葛西")}
    let!(:user_2) { create(:user, address: "東京都足立区栗原") }
    let!(:user_3) { create(:user, address: "東京都江戸川区一之江") }
    it "引数に部分一致するaddressを持つuserは検索される" do
      expect(User.address_like("江戸川区")).to include(user_1, user_3)
    end

    it "引数に全く一致しないaddressを持つuserは検索されない" do
      expect(User.address_like("江戸川区")).to_not include(user_2)
    end
  end

  describe "wanted_true" do
    let!(:user_1) { create(:user, wanted: true) }
    let!(:user_2) { create(:user, wanted: true) }
    let!(:user_3) { create(:user, wanted: false) }

    it "引数が空でないならばwantedがtrueのuserを検索する" do
      expect(User.wanted_true("true")).to include(user_1, user_2)
    end

    it "引数が空ならば全てのuserを検索する" do
      expect(User.wanted_true("")).to include(user_1, user_2, user_3) 
    end
  end

  describe "id_include" do
    let!(:user_1) { create(:user, id: 1) }
    let!(:user_2) { create(:user, id: 2) }
    let!(:user_3) { create(:user, id: 3) }

    it "引数のparamsが空でなく、引数のidsが空でないとき指定されたidを持つuserを検索する" do
      expect(User.id_include([ 1, 3 ], [ 10, 20 ])).to include(user_1, user_3)
    end

    it "引数のparamsが空でなく、引数のidsが空でないとき指定外のidを持つuserは検索されない" do
      expect(User.id_include([ 1, 3 ], [ 10, 20 ])).to_not include(user_2)
    end

    it "引数のparamsが空なとき全てのuserを返す" do
      expect(User.id_include([ 1, 3 ], [] )).to include(user_1, user_2, user_3)
    end
  end
end