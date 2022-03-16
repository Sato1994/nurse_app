# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Host, type: :model do
  describe 'name' do
    it 'なければ無効' do
      host = build(:host, name: nil)
      host.valid?
      expect(host.errors[:name]).to include("can't be blank")
    end

    it '40字を超える場合無効' do
      host = build(:host, name: '餅' * 41)
      host.valid?
      expect(host.errors[:name]).to include('is too long (maximum is 40 characters)')
    end
  end

  describe 'email' do
    it 'なければ無効' do
      host = build(:host, email: nil)
      host.valid?
      expect(host.errors[:email]).to include("can't be blank")
    end

    it '重複した場合無効' do
      host1 = create(:host)
      host2 = build(:host, email: host1.email)
      host2.valid?
      expect(host2.errors[:email]).to include('has already been taken')
    end
  end

  describe 'myid' do
    it 'なければ無効' do
      host = build(:host, myid: nil)
      host.valid?
      expect(host.errors[:myid]).to include("can't be blank")
    end

    it '15字を超える場合無効' do
      host = build(:host, myid: 'a' * 16)
      host.valid?
      expect(host.errors[:myid]).to include('is too long (maximum is 15 characters)')
    end

    it '重複した場合無効' do
      host1 = create(:host)
      host2 = build(:host, myid: host1.myid)
      host2.valid?
      expect(host2.errors[:myid]).to include('has already been taken')
    end
  end

  describe 'phone' do
    it 'なければ無効' do
      host = build(:host, phone: nil)
      host.valid?
      expect(host.errors[:phone]).to include("can't be blank")
    end

    it '11字を越えると無効' do
      host = build(:host, phone: '090123456789')
      expect(host).to be_invalid
    end
  end

  it 'passwordがなければ無効' do
    host = build(:host, password: nil)
    host.valid?
    expect(host.errors[:password]).to include("can't be blank")
  end

  it 'nameとemailとpasswordとmyid,phoneがあれば有効' do
    host = build(:host)
    host.valid?
    expect(host).to be_valid
  end

  it 'profileが300字を超える場合無効' do
    host = build(:host, profile: '餅' * 301)
    host.valid?
    expect(host.errors[:profile]).to include('is too long (maximum is 300 characters)')
  end

  it 'すべてのオリジナルカラムが入力可能な状態' do
    host = build(:host, address: 'mochimugi', image: 'mochimugi', wanted: true, profile: 'モチムギ')
    host.valid?
    expect(host).to be_valid
  end

  ########## メソッド ##########
  describe 'name_like' do
    let!(:host1) { create(:host, name: '東京病院') }
    let!(:host2) { create(:host, name: '千葉病院') }
    let!(:host3) { create(:host, name: '茨城病院') }

    it '引数に部分一致するnameを持つhostは検索される' do
      expect(described_class.name_like('茨城')).to include(host3)
    end

    it '引数に全く一致しないnameを持つhostは検索されない' do
      expect(described_class.name_like('茨城')).not_to include(host1, host2)
    end
  end

  describe 'address_like' do
    let!(:host1) { create(:host, address: '東京都江戸川区葛西') }
    let!(:host2) { create(:host, address: '東京都足立区栗原') }
    let!(:host3) { create(:host, address: '東京都江戸川区一之江') }

    it '引数に部分一致するaddressを持つhostは検索される' do
      expect(described_class.address_like('江戸川区')).to include(host1, host3)
    end

    it '引数に全く一致しないaddressを持つhostは検索されない' do
      expect(described_class.address_like('江戸川区')).not_to include(host2)
    end
  end

  describe 'wanted_true' do
    let!(:host1) { create(:host, wanted: true) }
    let!(:host2) { create(:host, wanted: true) }
    let!(:host3) { create(:host, wanted: false) }

    it '引数が空でないならばwantedがtrueのhostを検索する' do
      expect(described_class.wanted_true('true')).to include(host1, host2)
    end

    it '引数が空ならば全てのhostを検索する' do
      expect(described_class.wanted_true('')).to include(host1, host2, host3)
    end
  end

  describe 'id_include' do
    let!(:host1) { create(:host, id: 1) }
    let!(:host2) { create(:host, id: 2) }
    let!(:host3) { create(:host, id: 3) }

    it '引数のparamsが空でなく、引数のidsが空でないとき指定されたidを持つhostを検索する' do
      expect(described_class.id_include([1, 3], [10, 20])).to include(host1, host3)
    end

    it '引数のparamsが空でなく、引数のidsが空でないとき指定外のidを持つhostは検索されない' do
      expect(described_class.id_include([1, 3], [10, 20])).not_to include(host2)
    end

    it '引数のparamsが空なとき全てのhostを返す' do
      expect(described_class.id_include([1, 3], [])).to include(host1, host2, host3)
    end
  end
end
