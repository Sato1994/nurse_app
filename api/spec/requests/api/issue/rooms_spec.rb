# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Issue::Rooms', type: :request do
  let(:headers) do
    { uid: response.headers['uid'], client: response.headers['client'],
      'access-token': response.headers['access-token'] }
  end

  let(:json) { JSON.parse(response.body) }

  describe 'GET /show' do
    let(:room) { create(:room) }

    context '他人がログイン' do
      before do
        user2 = create(:user)
        post '/api/user/sign_in', params: { email: user2.email, password: user2.password }
        get "/api/rooms/#{room.id}", headers: headers
      end

      it 'jsonを返さない' do
        expect(json).to be_nil
      end

      it 'status unauthorized(401)を返す' do
        expect(response.status).to eq(401)
      end
    end

    context 'userがログイン' do
      before do
        post '/api/user/sign_in', params: { email: room.user.email, password: room.user.password }
      end

      it 'プロパティroomは期待した数のjsonを返す' do
        get "/api/rooms/#{room.id}", headers: headers

        expect(json['room'].count).to eq(8)
      end

      context 'プロパティagreement' do
        it '紐づいたroomがあるとき期待した数のjsonを返す' do
          create(:agreement, user: room.user, host: room.host, room: room, start_time: room.start_time,
                             finish_time: room.finish_time)
          get "/api/rooms/#{room.id}", headers: headers

          expect(json['agreement'].count).to eq(4)
        end

        it '紐づいたroomがないときnullを返す' do
          get "/api/rooms/#{room.id}", headers: headers

          expect(json['agreement']).to be_nil
        end
      end
    end

    context 'hostがログイン' do
      before do
        post '/api/host/sign_in', params: { email: room.host.email, password: room.host.password }
      end

      it 'プロパティroomは期待した数のjsonを返す' do
        get "/api/rooms/#{room.id}", headers: headers

        expect(json['room'].count).to eq(8)
      end

      context 'プロパティagreement' do
        it '紐づいたroomがあるとき期待した数のjsonを返す' do
          create(:agreement, user: room.user, host: room.host, room: room, start_time: room.start_time,
                             finish_time: room.finish_time)
          get "/api/rooms/#{room.id}", headers: headers

          expect(json['agreement'].count).to eq(4)
        end

        it '紐づいたroomがないときnullを返す' do
          get "/api/rooms/#{room.id}", headers: headers

          expect(json['agreement']).to be_nil
        end
      end
    end
  end

  describe 'POST /create' do
    let!(:free_time) { create(:free_time) }
    let!(:recruitment_time) { create(:recruitment_time) }
    let!(:user_request) { create(:user_request) }
    let!(:host_request) { create(:host_request) }

    context 'userとしてログインしている場合' do
      let(:params) do
        { request_id: host_request.id }
      end

      before do
        post '/api/user/sign_in', params: { email: free_time.user.email, password: free_time.user.password }
      end

      context 'roomを作成すると' do
        before do
          post '/api/rooms', params: params, headers: headers
        end

        it 'roomが一つ増える' do
          expect(Room.count).to eq(1)
        end

        it 'host_noticeが作られる' do
          expect(HostNotice.count).to eq(1)
        end

        it 'プロパティroomは期待した数のプロパティを返す' do
          expect(json['room'].count).to eq(7)
        end

        it 'ステータス201を返す' do
          expect(response.status).to eq(201)
        end
      end

      it '作成したらhost_requestが削除される' do
        expect do
          post '/api/rooms', params: params, headers: headers
        end.to change(HostRequest, :count).by(-1)
      end
    end

    context 'hostとしてログインしている場合' do
      let(:params) do
        { request_id: user_request.id }
      end

      before do
        post '/api/host/sign_in',
             params: { email: recruitment_time.host.email, password: recruitment_time.host.password }
      end

      context 'roomを作成すると' do
        before do
          post '/api/rooms', params: params, headers: headers
        end

        it 'roomが一つ増える' do
          expect(Room.count).to eq(1)
        end

        it 'user_noticeが作られる' do
          expect(UserNotice.count).to eq(1)
        end

        it '必要カラムだけのjsonを返す' do
          expect(json['room'].count).to eq(7)
        end

        it 'ステータス201を返す' do
          expect(response.status).to eq(201)
        end
      end

      it '作成したらuser_requestが削除される' do
        expect do
          post '/api/rooms', params: params, headers: headers
        end.to change(UserRequest, :count).by(-1)
      end
    end

    context 'ログインしていない場合' do
      before do
        post '/api/rooms',
             params: { start_time: user_request.start_time, finish_time: user_request.finish_time,
                       request_id: user_request.id }
      end

      it '失敗する' do
        expect(Room.count).to eq(0)
      end

      it '失敗したらuser_noticeは作られない' do
        expect(UserNotice.count).to eq(0)
      end
    end
  end

  describe 'PATCh /update_room_time' do
    let(:room) { create(:room) }

    it 'ログインしていなければ更新されない' do
      expect do
        patch "/api/rooms/update_room_time",
              params: { room_id: room.id, start_time: 22.hours.from_now, finish_time: 28.hours.from_now }
      end.not_to change { room.reload.start_time }
    end

    context 'userとしてログイン' do
      it '自分のroomなら更新される' do
        user_login
        expect do
          patch "/api/rooms/update_room_time",
                params: { room_id: room.id, start_time: 22.hours.from_now, finish_time: 28.hours.from_now },
                headers: headers
        end.to change { room.reload.start_time }
      end

      it '自分のroomでなければ更新されない' do
        room2 = create(:room)
        user_login
        expect do
          patch "/api/rooms/update_room_time",
                params: { room_id: room2.id, start_time: 22.hours.from_now, finish_time: 28.hours.from_now },
                headers: headers
        end.not_to change { room.reload.start_time }
      end

      context 'host_noticeとの連携' do
        it '同一source、同一actionが存在してもcheckedがtrueならば作成される' do
          user_login
          host_notice = create(:host_notice, source: room, host: room.host, action: 'changed', checked: true)
          expect do
            patch "/api/rooms/update_room_time",
                  params: { room_id: room.id, start_time: 22.hours.from_now, finish_time: 28.hours.from_now },
                  headers: headers
          end.to change(HostNotice, :count).to(2).from(1)
        end

        it '同一source、同一actionが存在しておりcheckedがfalseならば作成されない' do
          user_login
          host_notice = create(:host_notice, source: room, host: room.host, action: 'changed', checked: false)
          expect do
            patch "/api/rooms/update_room_time",
                  params: { room_id: room.id, start_time: 22.hours.from_now, finish_time: 28.hours.from_now },
                  headers: headers
          end.not_to change(HostNotice, :count)
        end
      end
    end

    context 'hostとしてログイン' do
      it '自分のroomなら更新される' do
        host_login
        expect do
          patch "/api/rooms/update_room_time",
                params: { room_id: room.id, start_time: 22.hours.from_now, finish_time: 28.hours.from_now },
                headers: headers
        end.to change { room.reload.start_time }
      end

      it '自分のroomでなければ更新されない' do
        room2 = create(:room)
        host_login
        expect do
          patch "/api/rooms/update_room_time",
                params: { room_id: room2.id, start_time: 22.hours.from_now, finish_time: 28.hours.from_now },
                headers: headers
        end.not_to change { room.reload.start_time }
      end

      context 'user_noticeとの連携' do
        it '同一source、同一actionが存在してもcheckedがtrueならば作成される' do
          host_login
          user_notice = create(:user_notice, source: room, user: room.user, action: 'changed', checked: true)
          expect do
            patch "/api/rooms/update_room_time",
                  params: { room_id: room.id, start_time: 22.hours.from_now, finish_time: 28.hours.from_now },
                  headers: headers
          end.to change(UserNotice, :count).to(2).from(1)
        end

        it '同一source、同一actionが存在しておりcheckedがfalseならば作成されない' do
          host_login
          user_notice = create(:user_notice, source: room, user: room.user, action: 'changed', checked: false)
          expect do
            patch "/api/rooms/update_room_time",
                  params: { room_id: room.id, start_time: 22.hours.from_now, finish_time: 28.hours.from_now },
                  headers: headers
          end.not_to change(UserNotice, :count)
        end
      end
    end

    def user_login
      post '/api/user/sign_in', params: { email: room.user.email, password: room.user.password }
    end

    def host_login
      post '/api/host/sign_in', params: { email: room.host.email, password: room.host.password }
    end
  end

  describe 'PATCH /update_room_state' do
    it 'ログインしていなければ更新されない' do
      room = create(:room, state: 'user')
      expect do
        patch "/api/rooms/update_room_state", params: { room_id: room.id }
      end.not_to change { room.reload.state }
    end

    context 'userがログイン' do
      it 'stateがnegotiatingでstart,finsish間が18時間ちょうどならuserへ変更される' do
        room = create(:room, finish_time: 39.hours.from_now.change(usec: 0))
        post '/api/user/sign_in', params: { email: room.user.email, password: room.user.password }
        expect do
          patch "/api/rooms/update_room_state", params: { room_id: room.id }, headers: headers
        end.to change { room.reload.state }.to 'user'
      end

      it 'stateがnegotiatingでstart,finsish間が18時間より大きければ期待するmessageを返す' do
        room = create(:room, finish_time: 39.hours.from_now.change(usec: 0) + 2.second)
        post '/api/user/sign_in', params: { email: room.user.email, password: room.user.password }
        patch "/api/rooms/update_room_state", params: { room_id: room.id }, headers: headers
        expect(response.body).to include('勤務時間は18時間以内にする必要があります。')
      end

      it 'stateがuserならnegotiatingへ変更される' do
        room = create(:room, state: 'user')
        post '/api/user/sign_in', params: { email: room.user.email, password: room.user.password }
        expect do
          patch "/api/rooms/update_room_state", params: { room_id: room.id }, headers: headers
        end.to change { room.reload.state }.to 'negotiating'
      end

      it 'stateがhostならconclusionへ変更される' do
        room = create(:room, state: 'host')
        post '/api/user/sign_in', params: { email: room.user.email, password: room.user.password }
        expect do
          patch "/api/rooms/update_room_state", params: { room_id: room.id }, headers: headers
        end.to change { room.reload.state }.to 'conclusion'
      end

      it 'stateがその他ならば変更されない' do
        room = create(:room, state: 'conclusion')
        post '/api/user/sign_in', params: { email: room.user.email, password: room.user.password }
        expect do
          patch "/api/rooms/update_room_state", params: { room_id: room.id }, headers: headers
        end.not_to change { room.reload.state }
      end

      context 'host_noticeとの連携' do
        context 'stateがuserへ変更された場合' do
          it '同一source、同一actionが存在してもcheckedがtrueならば作成される' do
            room = create(:room, state: 'negotiating')
            post '/api/user/sign_in', params: { email: room.user.email, password: room.user.password }
            host_notice = create(:host_notice, host: room.host, source: room, action: 'agreed', checked: true)
            expect do
              patch "/api/rooms/update_room_state", params: { room_id: room.id }, headers: headers
            end.to change(HostNotice, :count).to(2).from(1)
          end

          it '同一source、同一actionが存在しておりcheckedがfalseならば作成されない' do
            room = create(:room, state: 'negotiating')
            post '/api/user/sign_in', params: { email: room.user.email, password: room.user.password }
            host_notice = create(:host_notice, host: room.host, source: room, action: 'agreed', checked: false)
            expect do
              patch "/api/rooms/update_room_state", params: { room_id: room.id }, headers: headers
            end.not_to change(HostNotice, :count)
          end
        end

        it 'stateがuser以外へ変更された場合にはhost_noticeは作成されない' do
          array = %w[user host conclusion cancelled]
          array.each do |i|
            room = create(:room, state: i)
            post '/api/user/sign_in', params: { email: room.user.email, password: room.user.password }
            host_notice = create(:host_notice, host: room.host, source: room, action: 'agreed', checked: true)
            expect do
              patch "/api/rooms/update_room_state", params: { room_id: room.id }, headers: headers
            end.not_to change(HostNotice, :count)
          end
        end
      end
    end

    context 'hostがログイン' do
      it 'stateがnegotiatingならhostへ変更される' do
        room = create(:room, state: 'negotiating')
        post '/api/host/sign_in', params: { email: room.host.email, password: room.host.password }
        expect do
          patch "/api/rooms/update_room_state", params: { room_id: room.id }, headers: headers
        end.to change { room.reload.state }.to 'host'
      end

      it 'stateがuserならconclusionへ変更される' do
        room = create(:room, state: 'user')
        post '/api/host/sign_in', params: { email: room.host.email, password: room.host.password }
        expect do
          patch "/api/rooms/update_room_state", params: { room_id: room.id }, headers: headers
        end.to change { room.reload.state }.to 'conclusion'
      end

      it 'stateがhostならnegotiatingへ変更される' do
        room = create(:room, state: 'host')
        post '/api/host/sign_in', params: { email: room.host.email, password: room.host.password }
        expect do
          patch "/api/rooms/update_room_state", params: { room_id: room.id }, headers: headers
        end.to change { room.reload.state }.to 'negotiating'
      end

      it 'stateがその他ならば変更されない' do
        room = create(:room, state: 'conclusion')
        post '/api/host/sign_in', params: { email: room.host.email, password: room.host.password }
        expect do
          patch "/api/rooms/update_room_state", params: { room_id: room.id }, headers: headers
        end.not_to change { room.reload.state }
      end

      context 'user_noticeとの連携' do
        context 'stateがhostへ変更された場合' do
          it '同一source、同一actionが存在してもcheckedがtrueならば作成される' do
            room = create(:room, state: 'negotiating')
            post '/api/host/sign_in', params: { email: room.host.email, password: room.host.password }
            user_notice = create(:user_notice, user: room.user, source: room, action: 'agreed', checked: true)
            expect do
              patch "/api/rooms/update_room_state", params: { room_id: room.id }, headers: headers
            end.to change(UserNotice, :count).to(2).from(1)
          end

          it '同一source、同一actionが存在しておりcheckedがfalseならば作成されない' do
            room = create(:room, state: 'negotiating')
            post '/api/host/sign_in', params: { email: room.host.email, password: room.host.password }
            user_notice = create(:user_notice, user: room.user, source: room, action: 'agreed', checked: false)
            expect do
              patch "/api/rooms/update_room_state", params: { room_id: room.id }, headers: headers
            end.not_to change(UserNotice, :count)
          end
        end

        it 'stateがhost以外へ変更された場合にはuser_noticeは作成されない' do
          array = %w[user host conclusion cancelled]
          array.each do |i|
            room = create(:room, state: i)
            post '/api/host/sign_in', params: { email: room.host.email, password: room.host.password }
            user_notice = create(:user_notice, user: room.user, source: room, action: 'agreed', checked: true)
            expect do
              patch "/api/rooms/update_room_state", params: { room_id: room.id }, headers: headers
            end.not_to change(UserNotice, :count)
          end
        end
      end
    end
  end

  describe 'PATCH /cancell_room' do
    let!(:room) { create(:room) }

    context 'userとしてログインしている場合' do
      before do
        post '/api/user/sign_in', params: { email: room.user.email, password: room.user.password }
      end

      it 'stateが変更される' do
        expect  do
          patch '/api/rooms/cancell_room', params: { id: room.id }, headers: headers
        end.to change { room.reload.state }
      end

      it 'stateが変更された場合host_noticeが作成される' do
        expect  do
          patch '/api/rooms/cancell_room', params: { id: room.id }, headers: headers
        end.to change(HostNotice, :count).to(1).from(0)
      end

      it '成功したら適切な数のjsonを返す' do
        patch '/api/rooms/cancell_room', params: { id: room.id }, headers: headers
        expect(json.count).to eq(2)
      end
    end

    context 'hostとしてログインしている場合' do
      before do
        post '/api/host/sign_in', params: { email: room.host.email, password: room.host.password }
      end

      it 'stateが変更される' do
        expect  do
          patch '/api/rooms/cancell_room', params: { id: room.id }, headers: headers
        end.to change { room.reload.state }
      end

      it 'stateが変更された場合user_noticeが作成される' do
        expect  do
          patch '/api/rooms/cancell_room', params: { id: room.id }, headers: headers
        end.to change(UserNotice, :count).to(1).from(0)
      end

      it '成功したら適切なjsonを返す' do
        patch '/api/rooms/cancell_room', params: { id: room.id }, headers: headers
        expect(json.count).to eq(2)
      end
    end

    context 'roomの初期state' do
      it 'negotiatingの場合status200を返す' do
        room_negotiating = create(:room, state: 'negotiating')
        post '/api/user/sign_in', params: { email: room_negotiating.user.email, password: room_negotiating.user.password }
        patch '/api/rooms/cancell_room', params: { id: room_negotiating.id }, headers: headers
        expect(response.status).to eq(200)
      end

      it 'userの場合status200を返す' do
        room_user = create(:room, state: 'user')
        post '/api/user/sign_in', params: { email: room_user.user.email, password: room_user.user.password }
        patch '/api/rooms/cancell_room', params: { id: room_user.id }, headers: headers
        expect(response.status).to eq(200)
      end

      it 'hostの場合status200を返す' do
        room_host = create(:room, state: 'host')
        post '/api/user/sign_in', params: { email: room_host.user.email, password: room_host.user.password }
        patch '/api/rooms/cancell_room', params: { id: room_host.id }, headers: headers
        expect(response.status).to eq(200)
      end

      it 'conclusionの場合status400を返す' do
        room_conclusion = create(:room, state: 'conclusion')
        post '/api/user/sign_in', params: { email: room_conclusion.user.email, password: room_conclusion.user.password }
        patch '/api/rooms/cancell_room', params: { id: room_conclusion.id }, headers: headers
        expect(response.status).to eq(400)
      end

      it 'cancelledの場合status400を返す' do
        room_cancelled = create(:room, state: 'cancelled')
        post '/api/user/sign_in', params: { email: room_cancelled.user.email, password: room_cancelled.user.password }
        patch '/api/rooms/cancell_room', params: { id: room_cancelled.id }, headers: headers
        expect(response.status).to eq(400)
      end
    end

    context '他人がログインしている場合' do
      before do
        user = create(:user)
        post '/api/user/sign_in', params: { email: user.email, password: user.password }
      end

      it 'stateは変更されない' do
        expect  do
          patch '/api/rooms/cancell_room', params: { id: room.id }, headers: headers
        end.not_to change { room.reload.closed }
      end

      it 'ステータス403を返す' do
        patch '/api/rooms/cancell_room', params: { id: room.id }, headers: headers
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'PATCH /leave' do
    let!(:room) { create(:room) }

    context 'userとしてログイン' do
      before do
        post '/api/user/sign_in', params: { email: room.user.email, password: room.user.password }
      end

      it 'closedが変更される' do
        expect  do
          patch '/api/rooms/leave', params: { id: room.id }, headers: headers
        end.to change { room.reload.closed }
      end

      it '成功したら適切な数のjsonを返す' do
        patch '/api/rooms/leave', params: { id: room.id }, headers: headers
        expect(json.count).to eq(1)
      end
    end

    context 'hostとしてログイン' do
      before do
        post '/api/host/sign_in', params: { email: room.host.email, password: room.host.password }
      end

      it 'closedが変更される' do
        expect  do
          patch '/api/rooms/leave', params: { id: room.id }, headers: headers
        end.to change { room.reload.closed }
      end

      it '成功したら適切な数のjsonを返す' do
        patch '/api/rooms/leave', params: { id: room.id }, headers: headers
        expect(json.count).to eq(1)
      end
    end
  end
end
