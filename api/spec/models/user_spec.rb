# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'name' do
    it 'なければ無効' do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end

    it '20字を超える場合無効' do
      user = build(:user, name: '餅' * 21)
      user.valid?
      expect(user.errors[:name]).to include('is too long (maximum is 20 characters)')
    end
  end

  describe 'email' do
    it 'なければ無効' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end

    it '重複した場合無効' do
      user1 = create(:user)
      user2 = build(:user, email: user1.email)
      user2.valid?
      expect(user2.errors[:email]).to include('has already been taken')
    end
  end

  describe 'myid' do
    it 'なければ無効' do
      user = build(:user, myid: nil)
      user.valid?
      expect(user.errors[:myid]).to include("can't be blank")
    end

    it '15字を超える場合無効' do
      user = build(:user, myid: 'a' * 16)
      user.valid?
      expect(user.errors[:myid]).to include('is too long (maximum is 15 characters)')
    end

    it '重複した場合無効' do
      user1 = create(:user)
      user2 = build(:user, myid: user1.myid)
      user2.valid?
      expect(user2.errors[:myid]).to include('has already been taken')
    end
  end

  it 'passwordがなければ無効' do
    user = build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  it 'nameとemailとpasswordとmyidがあれば有効' do
    user = build(:user)
    user.valid?
    expect(user).to be_valid
  end

  it 'profileが300字を超える場合無効' do
    user = build(:user, profile: '餅' * 301)
    user.valid?
    expect(user.errors[:profile]).to include('is too long (maximum is 300 characters)')
  end

  describe 'age' do
    it '20未満の場合無効' do
      user = build(:user, age: 19)
      user.valid?
      expect(user.errors[:age]).to include('must be greater than or equal to 20')
    end

    it '60を超える場合無効' do
      user = build(:user, age: 61)
      user.valid?
      expect(user.errors[:age]).to include('must be less than or equal to 60')
    end
  end

  it 'yearが40以上の場合無効' do
    user = build(:user, year: 40)
    user.valid?
    expect(user.errors[:year]).to include('must be less than 40')
  end

  it 'すべてのオリジナルカラムが入力可能な状態' do
    user = build(:user, address: 'mochimugi', image: 'mochimugi', wanted: true, sex: true, age: 20, year: 20,
                        profile: 'モチムギ')
    user.valid?
    expect(user).to be_valid
  end

  describe 'year_gt' do
    let!(:user1) { create(:user, year: 0) }
    let!(:user2) { create(:user, year: 1) }
    let!(:user3) { create(:user, year: 2) }

    it '引数の数以上のyearを持つuserが検索される' do
      expect(described_class.year_gt(1)).to include(user2, user3)
    end

    it '引数の数未満のyearを持つuserは検索されない' do
      expect(described_class.year_gt(1)).not_to include(user1)
    end
  end

  describe 'address_like' do
    let!(:user1) { create(:user, address: '東京都江戸川区葛西') }
    let!(:user2) { create(:user, address: '東京都足立区栗原') }
    let!(:user3) { create(:user, address: '東京都江戸川区一之江') }

    it '引数に部分一致するaddressを持つuserは検索される' do
      expect(described_class.address_like('江戸川区')).to include(user1, user3)
    end

    it '引数に全く一致しないaddressを持つuserは検索されない' do
      expect(described_class.address_like('江戸川区')).not_to include(user2)
    end
  end

  describe 'wanted_true' do
    let!(:user1) { create(:user, wanted: true) }
    let!(:user2) { create(:user, wanted: true) }
    let!(:user3) { create(:user, wanted: false) }

    it '引数が空でないならばwantedがtrueのuserを検索する' do
      expect(described_class.wanted_true('true')).to include(user1, user2)
    end

    it '引数が空ならば全てのuserを検索する' do
      expect(described_class.wanted_true('')).to include(user1, user2, user3)
    end
  end

  describe 'id_include' do
    let!(:user1) { create(:user, id: 1) }
    let!(:user2) { create(:user, id: 2) }
    let!(:user3) { create(:user, id: 3) }

    it '引数のparamsが空でなく、引数のidsが空でないとき指定されたidを持つuserを検索する' do
      expect(described_class.id_include([1, 3], [10, 20])).to include(user1, user3)
    end

    it '引数のparamsが空でなく、引数のidsが空でないとき指定外のidを持つuserは検索されない' do
      expect(described_class.id_include([1, 3], [10, 20])).not_to include(user2)
    end

    it '引数のparamsが空なとき全てのuserを返す' do
      expect(described_class.id_include([1, 3], [])).to include(user1, user2, user3)
    end
  end

  describe 'soft_delete' do
    it 'nameが期待した値に変わる' do
      expect do
        user.soft_delete
      end.to change(user, :name).to('退会したユーザー')
    end

    it 'wantedがfalseに変わる' do
      expect do
        user.soft_delete
      end.to change(user, :wanted).to false
    end

    it 'deleteed_atが入力される' do
      expect do
        user.soft_delete
      end.to change(user, :deleted_at).to be_truthy
    end

    it 'free_timesが削除される' do
      create(:free_time, user: user)
      expect do
        user.soft_delete
      end.to change { user.free_times.count }.from(1).to(0)
    end

    it 'user_requestsが削除される' do
      user_request = create(:user_request)
      user = user_request.user
      expect do
        user.soft_delete
      end.to change { user.user_requests.count }.from(1).to(0)
    end

    it 'host_requestsが削除される' do
      host_request = create(:host_request)
      user = host_request.free_time.user
      expect do
        user.soft_delete
      end.to change { user.host_requests.count }.from(1).to(0)
    end
  end

  describe 'active_for_authentication?' do
    it 'deleted_atが未入力ならtrueを返す' do
      expect(user.active_for_authentication?).to be(true)
    end

    it 'delete_atが入力済みならfalseを返す' do
      user = create(:user, deleted_at: Time.current)
      expect(user.active_for_authentication?).to be(false)
    end
  end

  describe 'valid_agreements_exists?' do
    it '有効なagreementsが存在すればtrueを返す' do
      agreement = create(:agreement, user: user)
      expect(user.valid_agreements_exists?).to be(true)
    end

    it '有効なagreementsが存在しなければfalseを返す' do
      expect(user.valid_agreements_exists?).to be(false)
    end
  end

  describe 'valid_rooms_exists?' do
    it '有効なroomsが存在すればtrueを返す' do
      room = create(:room, user: user)
      expect(user.valid_rooms_exists?).to be(true)
    end

    it '有効なroomsが存在しなければfalseを返す' do
      expect(user.valid_rooms_exists?).to be(false)
    end
  end

  describe 'render_user' do
    it '期待する数のプロパティを返す' do
      expect(user.render_user.count).to eq(13)
    end
  end

  describe 'render_agreements' do
    it 'agreementが存在すれば期待する数のプロパティを返す' do
      create(:agreement, user: user)

      expect(user.render_agreements[0].count).to eq(6)
    end

    it '存在しなければ空の配列を返す' do
      expect(user.render_agreements).to eq([])
    end
  end

  describe 'render_rooms' do
    it 'roomsが存在すれば期待する数のプロパティを返す' do
      create(:room, user: user)
      expect(user.render_rooms[0].count).to eq(7)
    end

    it '存在しなければ空の配列を返す' do
      expect(user.render_rooms).to eq([])
    end
  end

  describe 'render_user_requests' do
    it 'user_requestsが存在すれば期待する数のプロパティを返す' do
      create(:user_request, user: user)
      expect(user.render_user_requests[0].count).to eq(4)
    end

    it '存在しなければ空の配列を返す' do
      expect(user.render_user_requests).to eq([])
    end
  end

  describe 'render_host_requests' do
    it 'host_requestsが存在すれば期待する数のプロパティを返す' do
      free_time = create(:free_time, user: user)
      create(:host_request, free_time: free_time)
      expect(user.render_host_requests[0].count).to eq(4)
    end

    it '存在しなければ空の配列を返す' do
      expect(user.render_host_requests).to eq([])
    end
  end

  describe 'render_user_notices' do
    it 'user_noticesが存在すれば期待する数のプロパティを返す' do
      create(:user_notice, user: user)
      expect(user.render_user_notices[0].count).to eq(7)
    end

    it '存在しなければ空の配列を返す' do
      expect(user.render_user_notices).to eq([])
    end
  end

  describe 'render_free_times' do
    it 'free_timesが存在すれば期待する数のプロパティを返す' do
      create(:free_time, user: user)
      expect(user.render_free_times[0].count).to eq(3)
    end

    it '存在しなければ空の配列を返す' do
      expect(user.render_free_times).to eq([])
    end
  end

  describe 'render_user_skills' do
    it 'user_skillsが存在すれば期待する数のプロパティを返す' do
      create(:user_skill, user: user)
      expect(user.render_user_skills[0].count).to eq(2)
    end

    it '存在しなければ空の配列を返す' do
      expect(user.render_user_skills).to eq([])
    end
  end
end
