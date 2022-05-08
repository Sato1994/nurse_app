# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Host, type: :model do
  let(:host) { create(:host) }

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

    it '13字を越えると無効' do
      host = build(:host, phone: '090-1234-56789')
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

  describe 'star_average' do
    it '評価の平均を返す' do
      rate_1 = create(:rate)
      agreement = create(:agreement, host: rate_1.agreement.host)
      rate_2 = create(:rate, :skip_validate, agreement: agreement)
      expect(rate_1.host.star_average).to eq((rate_1.star + rate_2.star) / 2.to_f.round(1))
    end

    it '評価数が0なら0を返す' do
      expect(host.star_average).to eq(0)
    end
  end

  describe 'soft_delete' do
    it 'nameが期待した値に変わる' do
      expect do
        host.soft_delete
      end.to change(host, :name).to('退会したユーザー')
    end

    it 'wantedがfalseに変わる' do
      expect do
        host.soft_delete
      end.to change(host, :wanted).to false
    end

    it 'deleteed_atが入力される' do
      expect do
        host.soft_delete
      end.to change(host, :deleted_at).to be_truthy
    end

    it 'recruitment_timesが削除される' do
      create(:recruitment_time, host: host)
      expect do
        host.soft_delete
      end.to change { host.recruitment_times.count }.from(1).to(0)
    end

    it 'host_requestsが削除される' do
      host_request = create(:host_request)
      host = host_request.host
      expect do
        host.soft_delete
      end.to change { host.host_requests.count }.from(1).to(0)
    end

    it 'user_requestsが削除される' do
      user_request = create(:user_request)
      host = user_request.recruitment_time.host
      expect do
        host.soft_delete
      end.to change { host.user_requests.count }.from(1).to(0)
    end
  end

  describe 'active_for_authentication?' do
    it 'deleted_atが未入力ならtrueを返す' do
      expect(host.active_for_authentication?).to be(true)
    end

    it 'delete_atが入力済みならfalseを返す' do
      host = create(:host, deleted_at: Time.current)
      expect(host.active_for_authentication?).to be(false)
    end
  end

  describe 'valid_agreements_exists?' do
    it '有効なagreementsが存在すればtrueを返す' do
      agreement = create(:agreement, host: host)
      expect(host.valid_agreements_exists?).to be(true)
    end

    it '有効なagreementsが存在しなければfalseを返す' do
      expect(host.valid_agreements_exists?).to be(false)
    end
  end

  describe 'valid_rooms_exists?' do
    it '有効なroomsが存在すればtrueを返す' do
      room = create(:room, host: host)
      expect(host.valid_rooms_exists?).to be(true)
    end

    it '有効なroomsが存在しなければfalseを返す' do
      expect(host.valid_rooms_exists?).to be(false)
    end
  end

  describe 'render_host' do
    it '期待する数のプロパティを返す' do
      expect(host.render_host.count).to eq(13)
    end
  end

  describe 'render_agreements' do
    it 'agreementが存在すれば期待する数のプロパティを返す' do
      create(:agreement, host: host)

      expect(host.render_agreements[0].count).to eq(6)
    end

    it '存在しなければ空の配列を返す' do
      expect(host.render_agreements).to eq([])
    end
  end

  describe 'render_rooms' do
    it 'roomsが存在すれば期待する数のプロパティを返す' do
      create(:room, host: host)
      expect(host.render_rooms[0].count).to eq(7)
    end

    it '存在しなければ空の配列を返す' do
      expect(host.render_rooms).to eq([])
    end
  end

  describe 'render_host_requests' do
    it 'host_requestsが存在すれば期待する数のプロパティを返す' do
      create(:host_request, host: host)
      expect(host.render_host_requests[0].count).to eq(4)
    end

    it '存在しなければ空の配列を返す' do
      expect(host.render_host_requests).to eq([])
    end
  end

  describe 'render_user_requests' do
    it 'user_requestsが存在すれば期待する数のプロパティを返す' do
      recruitment_time = create(:recruitment_time, host: host)
      create(:user_request, recruitment_time: recruitment_time)
      expect(host.render_user_requests[0].count).to eq(4)
    end

    it '存在しなければ空の配列を返す' do
      expect(host.render_user_requests).to eq([])
    end
  end

  describe 'render_host_notices' do
    it 'host_noticesが存在すれば期待する数のプロパティを返す' do
      create(:host_notice, host: host)
      expect(host.render_host_notices[0].count).to eq(7)
    end

    it '存在しなければ空の配列を返す' do
      expect(host.render_host_notices).to eq([])
    end
  end

  describe 'render_recruitment_times' do
    it 'recruitment_timesが存在すれば期待する数のプロパティを返す' do
      create(:recruitment_time, host: host)
      expect(host.render_recruitment_times[0].count).to eq(3)
    end

    it '存在しなければ空の配列を返す' do
      expect(host.render_recruitment_times).to eq([])
    end
  end

  describe 'render_host_skills' do
    it 'host_skillsが存在すれば期待する数のプロパティを返す' do
      create(:host_skill, host: host)
      expect(host.render_host_skills[0].count).to eq(2)
    end

    it '存在しなければ空の配列を返す' do
      expect(host.render_host_skills).to eq([])
    end
  end
end
