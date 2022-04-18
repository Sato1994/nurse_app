# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Agreements', type: :request do
  let(:headers) do
    { uid: response.headers['uid'], client: response.headers['client'],
      'access-token': response.headers['access-token'] }
  end

  let(:json) { JSON.parse(response.body) }

  describe 'GET /in_progress' do
    context 'userとしてログインしている場合' do
      before do
        user = create(:user)
        create(:agreement, user: user)
        post '/api/user/sign_in', params: { email: user.email, password: user.password }
        get '/api/agreements/in_progress', headers: headers
      end

      it 'プロパティagreementsは期待した数のプロパティを返す' do
        expect(json['agreements'][0].count).to eq(6)
      end

      it 'プロパティagreements.roomは期待した数のプロパティを返す' do
        expect(json['agreements'][0]['room'].count).to eq(1)
      end

      it 'プロパティagreements.partnerは期待した数のプロパティを返す' do
        expect(json['agreements'][0]['partner'].count).to eq(3)
      end
    end

    context 'hostとしてログインしている場合' do
      before do
        host = create(:host)
        create(:agreement, host: host)
        post '/api/host/sign_in', params: { email: host.email, password: host.password }
        get '/api/agreements/in_progress', headers: headers
      end

      it 'プロパティagreementsは期待した数のプロパティを返す' do
        expect(json['agreements'][0].count).to eq(6)
      end

      it 'プロパティagreements.roomは期待した数のプロパティを返す' do
        expect(json['agreements'][0]['room'].count).to eq(1)
      end

      it 'プロパティagreements.partnerは期待した数のプロパティを返す' do
        expect(json['agreements'][0]['partner'].count).to eq(2)
      end
    end
  end

  describe 'POST /create' do
    let!(:room) { create(:room) }
    let!(:params) do
      { room_id: room.id, start_time: Time.current.change(usec: 0) + 24.hours,
        finish_time: Time.current.change(usec: 0) + 32.hours }
    end

    context 'userとしてログインしている場合' do
      let(:correct_post) { post "/api/agreements/host/#{room.host.id}", params: params, headers: headers }

      before do
        post '/api/user/sign_in', params: { email: room.user.email, password: room.user.password }
      end

      context '未だagreementが作られていない場合' do
        it 'agreementを作成できる' do
          correct_post
          expect(Agreement.count).to eq(1)
        end

        it 'agreementが作成されたらhost_noticeが作成される' do
          correct_post
          expect(HostNotice.count).to eq(1)
        end

        it 'agreementを作成したらその期間と重複しているfree_timeが削除される' do
          create(:free_time, user: room.user)
          expect { correct_post }.to change(FreeTime, :count).from(1).to(0)
        end

        it '登録したらプロパティの数のjsonを返す' do
          correct_post
          expect(json.count).to eq(9)
        end

        it '登録したらステータス201を返す' do
          correct_post
          expect(response.status).to eq(201)
        end

        it '失敗したらステータス400を返す' do
          post "/api/agreements/host/#{room.host.id}",
               params: { room_id: room.id, start_time: '1000-08-06T00:00:00', finish_time: '1000-08-06T08:00:00' },
               headers: headers
          expect(response.status).to eq(400)
        end
      end

      context '既にagreementが作られておりupdateの場合' do
        before do
          create(:agreement, room: room, user: room.user, host: room.host, start_time: room.start_time,
                             finish_time: room.finish_time)
        end

        it 'agreementの時間を更新できる' do
          expect { correct_post }.to change { room.agreement.reload.start_time }
        end

        it 'agreementの時間を更新したらuser_noticeが作成される' do
          expect do
            correct_post
          end.to change(HostNotice, :count).to(1).from(0)
        end

        it '更新した時間帯と重複しているfree_timeが削除される' do
          create(:free_time, start_time: Time.current.change(usec: 0) + 30.hours,
                             finish_time: Time.current.change(usec: 0) + 38.hours, user: room.user)
          expect do
            post "/api/agreements/host/#{room.host.id}",
                 params: { room_id: room.id, start_time: Time.current.change(usec: 0) + 35.hours,
                           finish_time: Time.current.change(usec: 0) + 40.hours },
                 headers: headers
          end.to change(FreeTime, :count).from(1).to(0)
        end

        it '更新成功したらプロパティの数のjsonを返す' do
          correct_post
          expect(json.count).to eq(9)
        end

        it '更新成功したらステータス201を返す' do
          correct_post
          expect(response.status).to eq(200)
        end

        context '登録失敗' do
          before do
            post "/api/agreements/host/#{room.host.id}",
                 params: { room_id: room.id, start_time: '1000-08-06T00:00:00', finish_time: '1000-08-06T08:00:00' },
                 headers: headers
          end

          it 'ステータス400を返す' do
            expect(response.status).to eq(400)
          end

          it '失敗したらhost_noticeは作成されない' do
            expect(HostNotice.count).to eq(0)
          end
        end
      end
    end

    context 'hostとしてログインしている場合' do
      let(:correct_post) { post "/api/agreements/user/#{room.user.id}", params: params, headers: headers }

      before do
        post '/api/host/sign_in', params: { room_id: room.id, email: room.host.email, password: room.host.password }
      end

      context '未だagreementが作られていない場合' do
        it 'agreementを作成できる' do
          correct_post
          expect(Agreement.count).to eq(1)
        end

        it 'agreementが作成されたらuser_noticeが作成される' do
          correct_post
          expect(UserNotice.count).to eq(1)
        end

        it 'agreementを作成したらその期間と重複しているfree_timeが削除される' do
          create(:free_time, user: room.user)
          expect { correct_post }.to change(FreeTime, :count).from(1).to(0)
        end

        it '登録したらjsonを返す' do
          correct_post
          expect(json.count).to eq(9)
        end

        it '登録したらステータス201を返す' do
          correct_post
          expect(response.status).to eq(201)
        end

        context '登録失敗' do
          before do
            post "/api/agreements/user/#{room.user.id}",
                 params: { room_id: room.id, start_time: '1000-08-06T00:00:00', finish_time: '1000-08-06T08:00:00' },
                 headers: headers
          end

          it 'ステータス400を返す' do
            expect(response.status).to eq(400)
          end

          it '失敗したらuser_noticeは作成されない' do
            expect(UserNotice.count).to eq(0)
          end
        end
      end

      context '既にagreementが作られておりupdateの場合' do
        before do
          create(:agreement, room: room, user: room.user, host: room.host, start_time: room.start_time,
                             finish_time: room.finish_time)
        end

        it 'agreementの時間を更新できる' do
          expect { correct_post }.to change { room.agreement.reload.start_time }
        end

        it 'agreementの時間を更新したらuser_noticeが作成される' do
          expect do
            correct_post
          end.to change(UserNotice, :count).to(1).from(0)
        end

        it '更新した時間帯と重複しているfree_timeが削除される' do
          create(:free_time, start_time: Time.current.change(usec: 0) + 30.hours,
                             finish_time: Time.current.change(usec: 0) + 38.hours, user: room.user)
          expect do
            post "/api/agreements/user/#{room.user.id}",
                 params: { room_id: room.id, start_time: Time.current.change(usec: 0) + 35.hours,
                           finish_time: Time.current.change(usec: 0) + 40.hours },
                 headers: headers
          end.to change(FreeTime, :count).from(1).to(0)
        end

        it '更新成功したらプロパティの数のjsonを返す' do
          correct_post
          expect(json.count).to eq(9)
        end

        it '更新成功したらステータス201を返す' do
          correct_post
          expect(response.status).to eq(200)
        end

        it '失敗したときのステータス400を返す' do
          post "/api/agreements/host/#{room.user.id}",
               params: { room_id: room.id, start_time: Time.current.change(usec: 0) + 1.hour,
                         finish_time: Time.current.change(usec: 0) + 2.hours },
               headers: headers
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ステータス401を返す' do
        post "/api/agreements/user/#{room.user.id}", params: params
        expect(response.status).to eq(401)
      end

      it 'ステータス401を返す' do
        post "/api/agreements/host/#{room.host.id}", params: params
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'PATCH /update' do
    context 'userとしてログインしている場合' do
      before do
        post '/api/user/sign_in', params: { email: room.user.email, password: room.user.password }
      end

      let!(:agreement) do
        create(:agreement, room: room, start_time: room.start_time, finish_time: room.finish_time, user: room.user,
                           host: room.host)
      end
      let!(:room) do
        create(:room, state: 'conclusion', start_time: Time.current.change(usec: 0) + 24.hours + 1.minute,
                      finish_time: Time.current.change(usec: 0) + 30.hours)
      end

      it 'agreementのstart_timeが現在時刻から24時間以下の場合ステータス400を返す' do
        room = create(:room, state: 'conclusion', start_time: Time.current.change(usec: 0) + 24.hours,
                             finish_time: Time.current.change(usec: 0) + 30.hours)
        agreement = create(:agreement, room: room, start_time: room.start_time, finish_time: room.finish_time,
                                       user: room.user, host: room.host)
        post '/api/user/sign_in', params: { email: room.user.email, password: room.user.password }
        patch "/api/agreements/#{agreement.id}", headers: headers
        expect(response.status).to eq(400)
      end

      context 'agreementのstart_timeが現在時刻から48時間より猶予がある場合' do
        it 'agreement.stateがrequestingに変更される' do
          expect  do
            patch "/api/agreements/#{agreement.id}", headers: headers
          end.to change { agreement.reload.state }.from('before').to('requesting')
        end

        it 'agreement.stateがrequestingに変更されればhost_noticeが作成される' do
          expect  do
            patch "/api/agreements/#{agreement.id}", headers: headers
          end.to change(HostNotice, :count).to(1).from(0)
        end

        it 'room.stateがnegotiatingに変更される' do
          expect  do
            patch "/api/agreements/#{agreement.id}", headers: headers
          end.to change { room.reload.state }.from('conclusion').to('negotiating')
        end

        it '成功したら時のjsonを2つ返す' do
          patch "/api/agreements/#{agreement.id}", headers: headers
          expect(json.count).to eq(2)
        end

        it '成功したらステータス200を返す' do
          patch "/api/agreements/#{agreement.id}", headers: headers
          expect(response.status).to eq(200)
        end
      end
    end

    context 'hostとしてログインしている場合' do
      before do
        post '/api/host/sign_in', params: { email: room.host.email, password: room.host.password }
      end

      let!(:agreement) do
        create(:agreement, room: room, start_time: room.start_time, finish_time: room.finish_time, user: room.user,
                           host: room.host)
      end
      let!(:room) do
        create(:room, state: 'conclusion', start_time: Time.current.change(usec: 0) + 24.hours + 1.minute,
                      finish_time: Time.current.change(usec: 0) + 30.hours)
      end

      it 'agreementのstart_timeが現在時刻から48時間以下の場合ステータス400を返す' do
        room = create(:room, state: 'conclusion', start_time: Time.current.change(usec: 0) + 24.hours,
                             finish_time: Time.current.change(usec: 0) + 30.hours)
        agreement = create(:agreement, room: room, start_time: room.start_time, finish_time: room.finish_time,
                                       user: room.user, host: room.host)
        post '/api/host/sign_in', params: { email: room.host.email, password: room.host.password }
        patch "/api/agreements/#{agreement.id}", headers: headers
        expect(response.status).to eq(400)
      end

      context 'agreementのstart_timeが現在時刻から24時間より猶予がある場合' do
        it 'agreement.stateがrequestingに変更される' do
          expect  do
            patch "/api/agreements/#{agreement.id}", headers: headers
          end.to change { agreement.reload.state }.from('before').to('requesting')
        end

        it 'agreement.stateがrequestingに変更されればuser_noticeが作成される' do
          expect  do
            patch "/api/agreements/#{agreement.id}", headers: headers
          end.to change(UserNotice, :count).to(1).from(0)
        end

        it 'room.stateがnegotiatingに変更される' do
          expect  do
            patch "/api/agreements/#{agreement.id}", headers: headers
          end.to change { room.reload.state }.from('conclusion').to('negotiating')
        end

        it '成功したら時のjsonを2つ返す' do
          patch "/api/agreements/#{agreement.id}", headers: headers
          expect(json.count).to eq(2)
        end

        it '成功したらステータス200を返す' do
          patch "/api/agreements/#{agreement.id}", headers: headers
          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe 'PATCH /cancell' do
    describe '現時刻から48時間以上の猶予がある場合場合' do
      let!(:room) do
        create(:room, start_time: 100.hours.from_now.change(usec: 0), finish_time: 108.hours.from_now.change(usec: 0))
      end
      let!(:agreement) do
        create(:agreement, user: room.user, host: room.host, room: room, start_time: 103.hours.from_now.change(usec: 0),
                           finish_time: 111.hours.from_now.change(usec: 0))
      end

      before do
        post '/api/user/sign_in', params: { email: agreement.user.email, password: agreement.user.password }
      end

      it 'userとしてログインしていればagreement.stateをcancelledに変更できる' do
        patch '/api/agreements/cancell', params: { id: agreement.id }, headers: headers
        expect(agreement.reload.state).to eq('cancelled')
      end

      it 'agreementがキャンセルされればhost_noticeが作成される' do
        expect do
          patch '/api/agreements/cancell', params: { id: agreement.id }, headers: headers
        end.to change(HostNotice, :count).to(1).from(0)
      end

      it 'userとしてログインしていればroom.stateをcancelledに変更できる' do
        patch '/api/agreements/cancell', params: { id: agreement.id }, headers: headers
        expect(room.reload.state).to eq('cancelled')
      end

      it '他人のagreementはキャンセルできない' do
        user = create(:user)
        post '/api/user/sign_in', params: { email: user.email, password: user.password }
        expect  do
          patch '/api/agreements/cancell', params: { id: agreement.id }, headers: headers
        end.not_to change { agreement.reload.state }
      end
    end

    describe '現時刻から48時間以内のもの' do
      let!(:room) { create(:room) }
      let!(:agreement) { create(:agreement, user: room.user, host: room.host, room: room) }

      before do
        post '/api/user/sign_in', params: { email: agreement.user.email, password: agreement.user.password }
      end

      describe 'パラメータにcommentがあるとき' do
        it 'cancell_commentが作成される' do
          expect do
            patch '/api/agreements/cancell', params: { id: agreement.id, comment: 'こんにちは' }, headers: headers
          end.to change(CancellComment, :count).from(0).to(1)
        end

        it 'room.stateがcancelledに変更される' do
          expect do
            patch '/api/agreements/cancell', params: { id: agreement.id, comment: 'こんにちは' }, headers: headers
          end.to change { room.reload.state }.to('cancelled')
        end

        it 'agreementがキャンセルされればhost_noticeが作成される' do
          expect do
            patch '/api/agreements/cancell', params: { id: agreement.id, comment: 'こんにちは' }, headers: headers
          end.to change(HostNotice, :count).to(1).from(0)
        end

        it 'agreement.stateがcancelledに変更される' do
          expect do
            patch '/api/agreements/cancell', params: { id: agreement.id, comment: 'こんにちは' }, headers: headers
          end.to change { agreement.reload.state }.to('cancelled')
        end
      end

      describe 'パラメータにcommentがないとき' do
        it 'coomentがなければcancell_commentは作成されない' do
          expect do
            patch '/api/agreements/cancell', params: { id: agreement.id }, headers: headers
          end.not_to change { agreement.reload.state }
        end

        it 'room.stateは変更されない' do
          expect do
            patch '/api/agreements/cancell', params: { id: agreement.id }, headers: headers
          end.not_to change { room.reload.state }
        end

        it 'agreement.stateは変更されない' do
          expect do
            patch '/api/agreements/cancell', params: { id: agreement.id }, headers: headers
          end.not_to change { agreement.reload.state }
        end

        it 'status bad_requestを返す(400)' do
          patch '/api/agreements/cancell', params: { id: agreement.id }, headers: headers
          expect(response.status).to eq(400)
        end
      end

      describe '時間の境界テスト' do
        it '48時間ちょうどならcomment必要' do
          time = 48.hours.from_now.change(usec: 0)
          room = create(:room, start_time: time, finish_time: time + 8.hours)
          agreement = create(:agreement, user: room.user, host: room.host, room: room, start_time: time,
                                         finish_time: time + 8.hours)
          post '/api/user/sign_in', params: { email: agreement.user.email, password: agreement.user.password }
          patch '/api/agreements/cancell', params: { id: agreement.id }, headers: headers
          expect(agreement.reload.state).not_to eq('cancelled')
        end

        it '48時間以上ならcomment不要' do
          time = 48.hours.from_now.change(usec: 0) + 1.second
          room = create(:room, start_time: time, finish_time: time + 8.hours)
          agreement = create(:agreement, user: room.user, host: room.host, room: room, start_time: time,
                                         finish_time: time + 8.hours)
          post '/api/user/sign_in', params: { email: agreement.user.email, password: agreement.user.password }
          patch '/api/agreements/cancell', params: { id: agreement.id }, headers: headers
          expect(agreement.reload.state).to eq('cancelled')
        end
      end
    end
  end
end
