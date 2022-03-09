# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Rooms', type: :request do
  let(:headers) do
    { uid: response.headers['uid'], client: response.headers['client'],
      'access-token': response.headers['access-token'] }
  end

  describe 'POST /create' do
    let!(:free_time) { create(:free_time) }
    let!(:recruitment_time) { create(:recruitment_time) }
    let!(:user_request) { create(:user_request) }
    let!(:host_request) { create(:host_request) }

    context 'userとしてログインしている場合' do
      let(:params) do
        { start_time: host_request.start_time, finish_time: host_request.finish_time, request_id: host_request.id }
      end

      before do
        post '/api/user/sign_in', params: { email: free_time.user.email, password: free_time.user.password }
      end

      context 'roomを作成すると' do
        before do
          post "/api/rooms/host/#{host_request.host.id}", params: params, headers: headers
        end

        it 'roomが一つ増える' do
          expect(Room.count).to eq(1)
        end

        it '必要カラムだけのjsonを返す' do
          json = JSON.parse(response.body)
          expect(json.count).to eq(6)
        end

        it 'ステータス201を返す' do
          expect(response.status).to eq(201)
        end
      end

      it '作成したらhost_requestが削除される' do
        expect do
          post "/api/rooms/host/#{host_request.host.id}", params: params, headers: headers
        end.to change(HostRequest, :count).by(-1)
      end
    end

    context 'hostとしてログインしている場合' do
      let(:params) do
        { start_time: user_request.start_time, finish_time: user_request.finish_time, request_id: user_request.id }
      end

      before do
        post '/api/host/sign_in',
             params: { email: recruitment_time.host.email, password: recruitment_time.host.password }
      end

      context 'roomを作成すると' do
        before do
          post "/api/rooms/user/#{user_request.user.id}", params: params, headers: headers
        end

        it 'roomが一つ増える' do
          expect(Room.count).to eq(1)
        end

        it '必要カラムだけのjsonを返す' do
          json = JSON.parse(response.body)
          expect(json.count).to eq(6)
        end

        it 'ステータス201を返す' do
          expect(response.status).to eq(201)
        end
      end

      it '作成したらuser_requestが削除される' do
        expect do
          post "/api/rooms/user/#{user_request.user.id}", params: params, headers: headers
        end.to change(UserRequest, :count).by(-1)
      end
    end

    context 'ログインしていない場合' do
      it '失敗する' do
        post "/api/rooms/host/#{host_request.user.id}",
             params: { start_time: host_request.start_time, finish_time: host_request.finish_time,
                       request_id: host_request.id }
        expect(Room.count).to eq(0)
      end

      it '失敗する' do
        post "/api/rooms/user/#{user_request.user.id}",
             params: { start_time: user_request.start_time, finish_time: user_request.finish_time,
                       request_id: user_request.id }
        expect(Room.count).to eq(0)
      end
    end
  end

  describe 'PATCh /update' do
    let!(:room) { create(:room) }
    let!(:room_state_user) { create(:room, state: 'user') }
    let!(:room_state_host) { create(:room, state: 'host') }
    let!(:room_state_cancelled) { create(:room, state: 'cancelled') }

    context 'userとしてログインしており' do
      before do
        post '/api/user/sign_in', params: { email: room.user.email, password: room.user.password }
      end

      context 'リクエストにparams[:start_time]が存在する場合' do
        it 'Roomの期間を更新できる。' do
          patch "/api/rooms/#{room.id}",
                params: { host_id: room.host.id, start_time: 22.hours.from_now, finish_time: 28.hours.from_now },
                headers: headers
          expect(response.status).to eq(200)
        end

        it '失敗ならステータスコード400を返す' do
          patch "/api/rooms/#{room.id}",
                params: { host_id: room.host.id, start_time: 22.hours.from_now, finish_time: 1.year.from_now },
                headers: headers
          expect(response.status).to eq(400)
        end
      end

      context 'リクエストにparams[:start_time]が存在せず、stateが' do
        it 'negotiatingの場合userへ変更される' do
          expect  do
            patch "/api/rooms/#{room.id}",
                  headers: headers
          end.to change { room.reload.state }.from('negotiating').to('user')
        end

        it 'userの場合negotiatingへ変更される' do
          expect  do
            patch "/api/rooms/#{room_state_user.id}",
                  headers: headers
          end.to change { room_state_user.reload.state }.from('user').to('negotiating')
        end

        it 'hostの場合conclusionへ変更される' do
          expect  do
            patch "/api/rooms/#{room_state_host.id}",
                  headers: headers
          end.to change { room_state_host.reload.state }.from('host').to('conclusion')
        end

        it 'canselledの場合ステータスコード400を返す' do
          patch "/api/rooms/#{room_state_cancelled.id}",
                headers: headers
          expect(response.status).to eq(400)
        end
      end
    end

    context 'hostとしてログインしており' do
      before do
        post '/api/host/sign_in', params: { email: room.host.email, password: room.host.password }
      end

      context 'リクエストにparams[:start_time]が存在する場合' do
        it 'Roomの期間を更新できる。' do
          patch "/api/rooms/#{room.id}",
                params: { user_id: room.user.id, start_time: 22.hours.from_now, finish_time: 28.hours.from_now },
                headers: headers
          expect(response.status).to eq(200)
        end

        it '失敗ならステータスコード400を返す' do
          patch "/api/rooms/#{room.id}",
                params: { user_id: room.user.id, start_time: 22.hours.from_now, finish_time: 1.year.from_now },
                headers: headers
          expect(response.status).to eq(400)
        end
      end

      context 'リクエストにparams[:start_time]が存在せず、stateが' do
        it 'negotiatingの場合hostへ変更される' do
          expect  do
            patch "/api/rooms/#{room.id}", headers: headers
          end.to change { room.reload.state }.from('negotiating').to('host')
        end

        it 'hostの場合negotiatingへ変更される' do
          expect  do
            patch "/api/rooms/#{room_state_host.id}", headers: headers
          end.to change { room_state_host.reload.state }.from('host').to('negotiating')
        end

        it 'userの場合conclusionへ変更される' do
          expect  do
            patch "/api/rooms/#{room_state_user.id}", headers: headers
          end.to change { room_state_user.reload.state }.from('user').to('conclusion')
        end

        it 'canselledの場合ステータスコード400を返す' do
          patch "/api/rooms/#{room_state_cancelled.id}", headers: headers
          expect(response.status).to eq(400)
        end
      end
    end
  end

  describe 'PATCh /cancell_room' do
    let!(:room) { create(:room) }

    context 'userとしてログインしている場合' do
      before do
        post '/api/user/sign_in', params: { email: room.user.email, password: room.user.password }
      end

      it 'closedが変更される' do
        expect  do
          patch '/api/rooms/cancell_room', params: { id: room.id }, headers: headers
        end.to change { room.reload.closed }
      end

      it 'stateが変更される' do
        expect  do
          patch '/api/rooms/cancell_room', params: { id: room.id }, headers: headers
        end.to change { room.reload.state }
      end

      it '成功したら適切な数のjsonを返す' do
        json = JSON.parse(response.body)
        expect(json.count).to eq(1)
      end
    end

    context 'hostとしてログインしている場合' do
      before do
        post '/api/host/sign_in', params: { email: room.host.email, password: room.host.password }
      end

      it 'closedが変更される' do
        expect  do
          patch '/api/rooms/cancell_room', params: { id: room.id }, headers: headers
        end.to change { room.reload.closed }
      end

      it 'stateが変更される' do
        expect  do
          patch '/api/rooms/cancell_room', params: { id: room.id }, headers: headers
        end.to change { room.reload.state }
      end

      it '成功したら適切なjsonを返す' do
        json = JSON.parse(response.body)
        expect(json.count).to eq(1)
      end
    end

    context '他人がログインしている場合' do
      it 'closedは変更されない' do
        user = create(:user)
        post '/api/user/sign_in', params: { email: user.email, password: user.password }
        expect  do
          patch '/api/rooms/cancell_room', params: { id: room.id }, headers: headers
        end.not_to change { room.reload.closed }
      end
    end
  end
end
