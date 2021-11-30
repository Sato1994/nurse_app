require 'rails_helper'

RSpec.describe "Api::Agreements", type: :request do
  let(:headers) do
    { uid: response.headers["uid"], client: response.headers["client"], "access-token": response.headers["access-token"] }
  end
  
  describe "GET /index" do
    context "stateが0のものは勤務時間内であればstate1へ変更される" do
      it "userがログインしている場合" do
        create(:agreement, state: 0)
        agreement = create(:agreement, state: 0)
        user = agreement.user
        create(:agreement, user: user, start_time: Time.current.change(usec: 0) + 33.hour, finish_time: Time.current.change(usec: 0) + 41.hour)
        post "/api/user/sign_in", params: { email: user.email, password: user.password }
        travel 24.hour - 1.second
        get "/api/agreements", headers: headers
        travel 1.second
        expect{get "/api/agreements", headers: headers}.to change{Agreement.where(state: 1).count}.from(0).to(1)
      end

      it "hostがログインしている場合" do
        create(:agreement, state: 0)
        agreement = create(:agreement, state: 0)
        host = agreement.host
        create(:agreement, host: host, start_time: Time.current.change(usec: 0) + 33.hour, finish_time: Time.current.change(usec: 0) + 41.hour)
        post "/api/host/sign_in", params: { email: host.email, password: host.password }
        travel 24.hour - 1.second
        get "/api/agreements", headers: headers
        travel 1.second
        expect{get "/api/agreements", headers: headers}.to change{Agreement.where(state: 1).count}.from(0).to(1)
      end
    end

    context "atateが0か1のものは勤務終了時間後であればstate2へ変更される" do
      before do
        create(:agreement, state: 0)
        create(:agreement, state: 1)
      end
      let(:agreement) { create(:agreement, state: 0)}
      
      it "userがログインしている場合" do
        user = agreement.user
        create(:agreement, state: 1, user: user, start_time: Time.current.change(usec: 0) + 33.hour, finish_time: Time.current.change(usec: 0) + 41.hour)
        post "/api/user/sign_in", params: { email: user.email, password: user.password }
        travel 41.hour
        get "/api/agreements", headers: headers
        travel 1.second
        expect{get "/api/agreements", headers: headers}.to change{Agreement.where(state: 2).count}.from(1).to(2)
      end

      it "hostがログインしている場合" do
        host = agreement.host
        create(:agreement, state: 1, host: host, start_time: Time.current.change(usec: 0) + 33.hour, finish_time: Time.current.change(usec: 0) + 41.hour)
        post "/api/host/sign_in", params: { email: host.email, password: host.password }
        travel 41.hour
        get "/api/agreements", headers: headers
        travel 1.second
        expect{get "/api/agreements", headers: headers}.to change{Agreement.where(state: 2).count}.from(1).to(2)
      end
    end
    
    context "関与しているagreementの数だけjsonを返す" do
      let(:list) { create_list(:agreement, 10) }
      
      it "userがログインしている場合" do
        user = list.first.user
        create(:agreement, user: user, start_time: Time.current.change(usec: 0) + 33.hour, finish_time: Time.current.change(usec: 0) + 41.hour)
        post "/api/user/sign_in", params: { email: user.email, password: user.password }
        get "/api/agreements", headers: headers
        json = JSON.parse(response.body)
        expect(json.count).to eq(2)
      end

      it "hostがログインしている場合" do
        host = list.first.host
        create(:agreement, host: host, start_time: Time.current.change(usec: 0) + 33.hour, finish_time: Time.current.change(usec: 0) + 41.hour)
        post "/api/host/sign_in", params: { email: host.email, password: host.password }
        get "/api/agreements", headers: headers
        json = JSON.parse(response.body)
        expect(json.count).to eq(2)
      end
    end
    it "ログインしてない場合ステータス401を返す" do
      get "/api/agreements"
      expect(response.status).to eq(401)
    end
  end

  describe "POST /create" do
    let!(:room) { create(:room)}
    let!(:params) { {room_id: room.id, start_time: Time.current.change(usec: 0) + 24.hour, finish_time: Time.current.change(usec: 0) + 32.hour} }
    
    context "userとしてログインしている場合" do

      let(:correct_post) { post "/api/agreements/host/#{room.host.id}", params: params, headers: headers }
      before do
        post "/api/user/sign_in", params: { email: room.user.email, password: room.user.password }
      end
      
      context "未だagreementが作られて以内場合" do
        it "agreementを作成できる" do
          correct_post
          expect(Agreement.count).to eq(1)
        end
  
        it "agreementを作成したらその期間と重複しているfree_timeが削除される" do
          create(:free_time, user: room.user)
          expect{ correct_post }.to change { FreeTime.count}. from(1).to(0)
        end
  
        it "登録したらプロパティの数のjsonを返す" do
          correct_post
          json = JSON.parse(response.body)
          expect(json.count).to eq(9)
        end
  
        it "登録したらステータス201を返す" do
          correct_post
          expect(response.status).to eq(201)
        end
  
        it "失敗したらステータス400を返す" do
          post "/api/agreements/host/#{room.host.id}", params: {room_id: room.id, start_time: "1000-08-06T00:00:00", finish_time: "1000-08-06T08:00:00"}, headers: headers
          expect(response.status).to eq(400)
        end
      end
      
      context "既にagreementが作られておりupdateの場合" do
        before do
          create(:agreement, room: room, user: room.user, host: room.host, start_time: room.start_time, finish_time: room.finish_time)
        end
        
        it "agreementの時間を更新できる" do
          expect{ correct_post }.to change { room.agreement.reload.start_time}
        end

        it "更新した時間帯と重複しているfree_timeが削除される" do
          create(:free_time, start_time: Time.current.change(usec: 0) + 30.hour, finish_time: Time.current.change(usec: 0) + 38.hour, user: room.user)
          expect{
            post "/api/agreements/host/#{room.host.id}",
            params: {room_id: room.id, start_time: Time.current.change(usec: 0) + 35.hour, finish_time: Time.current.change(usec: 0) + 40.hour},
            headers: headers
          }.to change { FreeTime.count}. from(1).to(0)
        end

        it "更新成功したらプロパティの数のjsonを返す" do
          correct_post
          json = JSON.parse(response.body)
          expect(json.count).to eq(9)
        end

        it "更新成功したらステータス201を返す" do
          correct_post
          expect(response.status).to eq(200)
        end

        it "失敗したときのステータス400を返す" do
          post "/api/agreements/host/#{room.host.id}", params: {room_id: room.id, start_time: Time.current.change(usec: 0) + 1.hour, finish_time: Time.current.change(usec: 0) + 2.hour}, headers: headers
        end
      end
    end
    
    context "hostとしてログインしている場合" do
      let(:correct_post) { post "/api/agreements/user/#{room.user.id}", params: params, headers: headers}

      before do
        post "/api/host/sign_in", params: {room_id: room.id,  email: room.host.email, password: room.host.password }
      end
      
      context "未だagreementが作られて以内場合" do
        it "agreementを作成できる" do
          correct_post
          expect(Agreement.count).to eq(1)
        end
    
        it "agreementを作成したらその期間と重複しているfree_timeが削除される" do
          create(:free_time, user: room.user)
          expect{ correct_post }.to change { FreeTime.count}.from(1).to(0)
        end
    
        it "登録したらjsonを返す" do
          correct_post
          json = JSON.parse(response.body)
          expect(json.count).to eq(9)
        end
  
        it "登録したらステータス201を返す" do
          correct_post
          expect(response.status).to eq(201)
        end
  
        it "失敗したらステータス400を返す" do
          post "/api/agreements/user/#{room.user.id}", params: {room_id: room.id, start_time: "1000-08-06T00:00:00", finish_time: "1000-08-06T08:00:00"}, headers: headers
          expect(response.status).to eq(400)
        end
      end
      
      context "既にagreementが作られておりupdateの場合" do
        before do
          create(:agreement, room: room, user: room.user, host: room.host, start_time: room.start_time, finish_time: room.finish_time)
        end
        
        it "agreementの時間を更新できる" do
          expect{ correct_post }.to change { room.agreement.reload.start_time}
        end

        it "更新した時間帯と重複しているfree_timeが削除される" do
          create(:free_time, start_time: Time.current.change(usec: 0) + 30.hour, finish_time: Time.current.change(usec: 0) + 38.hour, user: room.user)
          expect{
            post "/api/agreements/user/#{room.user.id}",
            params: {room_id: room.id, start_time: Time.current.change(usec: 0) + 35.hour, finish_time: Time.current.change(usec: 0) + 40.hour},
            headers: headers
          }.to change { FreeTime.count}. from(1).to(0)
        end

        it "更新成功したらプロパティの数のjsonを返す" do
          correct_post
          json = JSON.parse(response.body)
          expect(json.count).to eq(9)
        end

        it "更新成功したらステータス201を返す" do
          correct_post
          expect(response.status).to eq(200)
        end

        it "失敗したときのステータス400を返す" do
          post "/api/agreements/host/#{room.user.id}", params: {room_id: room.id, start_time: Time.current.change(usec: 0) + 1.hour, finish_time: Time.current.change(usec: 0) + 2.hour}, headers: headers
        end
      end
    end
    
    context "ログインしていない場合" do
      it "ステータス401を返す" do
        post "/api/agreements/user/#{room.user.id}", params: params
        expect(response.status).to eq(401)
      end

      it "ステータス401を返す" do
        post "/api/agreements/host/#{room.host.id}", params: params
        expect(response.status).to eq(401)
      end
    end
  end

  describe "PATCH /create" do
    context "userとしてログインしている場合" do
      it "agreementのstart_timeが現在時刻から24時間以下の場合ステータス400を返す" do
        room = create(:room, consensus: "conclusion", start_time: Time.current.change(usec: 0) + 24.hour, finish_time: Time.current.change(usec: 0) + 30.hour)
        agreement = create(:agreement, room: room, start_time: room.start_time, finish_time: room.finish_time, user: room.user, host: room.host)
        post "/api/user/sign_in", params: { email: room.user.email, password: room.user.password }
        patch "/api/agreements/#{agreement.id}", headers: headers
        expect(response.status).to eq(400)
      end

      let!(:room) { create(:room, consensus: "conclusion", start_time: Time.current.change(usec: 0) + 24.hour + 1.minute, finish_time: Time.current.change(usec: 0) + 30.hour)}
      let!(:agreement) { create(:agreement, room: room, start_time: room.start_time, finish_time: room.finish_time, user: room.user, host: room.host) }

      before do
        post "/api/user/sign_in", params: { email: room.user.email, password: room.user.password }
      end

      context "agreementのstart_timeが現在時刻から24時間より猶予がある場合" do
        it "agreement.stateがrequestingに変更される" do
          expect{
            patch "/api/agreements/#{agreement.id}", headers: headers
          }.to change { agreement.reload.state}.from("before").to("requesting")
        end

        it "room.consensusがnegotiatingに変更される" do
          expect{
            patch "/api/agreements/#{agreement.id}", headers: headers
          }.to change { room.reload.consensus}.from("conclusion").to("negotiating")
        end

        it "成功したら時のjsonを2つ返す" do
          patch "/api/agreements/#{agreement.id}", headers: headers
          json = JSON.parse(response.body)
          expect(json.count).to eq(2)
        end

        it "成功したらステータス200を返す" do
          patch "/api/agreements/#{agreement.id}", headers: headers
          expect(response.status).to eq(200)
        end
      end
    end

    context "hostとしてログインしている場合" do
      it "agreementのstart_timeが現在時刻から24時間以下の場合ステータス400を返す" do
        room = create(:room, consensus: "conclusion", start_time: Time.current.change(usec: 0) + 24.hour, finish_time: Time.current.change(usec: 0) + 30.hour)
        agreement = create(:agreement, room: room, start_time: room.start_time, finish_time: room.finish_time, user: room.user, host: room.host)
        post "/api/host/sign_in", params: { email: room.host.email, password: room.host.password }
        patch "/api/agreements/#{agreement.id}", headers: headers
        expect(response.status).to eq(400)
      end

      let!(:room) { create(:room, consensus: "conclusion", start_time: Time.current.change(usec: 0) + 24.hour + 1.minute, finish_time: Time.current.change(usec: 0) + 30.hour)}
      let!(:agreement) { create(:agreement, room: room, start_time: room.start_time, finish_time: room.finish_time, user: room.user, host: room.host) }

      before do
        post "/api/host/sign_in", params: { email: room.host.email, password: room.host.password }
      end

      context "agreementのstart_timeが現在時刻から24時間より猶予がある場合" do
        it "agreement.stateがrequestingに変更される" do
          expect{
            patch "/api/agreements/#{agreement.id}", headers: headers
          }.to change { agreement.reload.state}.from("before").to("requesting")
        end

        it "room.consensusがnegotiatingに変更される" do
          expect{
            patch "/api/agreements/#{agreement.id}", headers: headers
          }.to change { room.reload.consensus}.from("conclusion").to("negotiating")
        end

        it "成功したら時のjsonを2つ返す" do
          patch "/api/agreements/#{agreement.id}", headers: headers
          json = JSON.parse(response.body)
          expect(json.count).to eq(2)
        end

        it "成功したらステータス200を返す" do
          patch "/api/agreements/#{agreement.id}", headers: headers
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
