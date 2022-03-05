require 'rails_helper'

RSpec.describe FreeTime, type: :model do
  describe 'user' do
    it "なければ無効" do
      ft = build(:free_time, user: nil)
      ft.valid?
      expect(ft.errors[:user]).to include("can't be blank")
    end
  end

  describe "start_time" do
    it "作成時点で開始時間まで12時間以上あれば有効" do
      ft = build(:free_time, start_time: Time.current + 12.hour + 1)
      expect(ft).to be_valid
    end

    it "作成時点で開始時間までちょうど12時間前ならば無効" do
      ft = build(:free_time, start_time: Time.current + 12.hour)
      ft.valid?
      expect(ft.errors[:start_time]).to include("登録時間は現在時刻より12時間以上時間の猶予が必要です。")
    end
  end

  describe "start_time, finish_time" do
    context "登録時間" do
      it "１時間なら有効" do
        ft = build(:free_time, finish_time: Time.current + 21.hour)
        expect(ft).to be_valid
      end

      it "1時間未満なら無効" do
        ft = build(:free_time, finish_time: Time.current + 21.hour - 1.second )
        ft.valid?
        expect(ft.errors[:start_time]).to include("登録時間は最低1時間以上です。")
      end
    end

    context "重複がある場合" do
      it "自分の持つ登録時間が重複すれば無効" do
        ft = create(:free_time)
        new_ft = build(:free_time, user: ft.user)
        new_ft.valid?
        expect(new_ft.errors[:start_time]).to include("登録時間が重複しています。")
      end
      
      it "自分の持つAgreementと重複すれば無効" do
        agreement = create(:agreement)
        ft = build(:free_time, user: agreement.user, start_time: Time.current + 32.hour, finish_time: Time.current + 42.hour)
        ft.valid?
        expect(ft.errors[:start_time]).to include("一度契約した時間では登録できません。")
      end
    end
  end
end