require 'rails_helper'

RSpec.describe "host登録", type: :request do
  describe "POST /api/host" do
    it "有効な値を入力した場合ユーザ登録できる" do
      post '/api/host', params: attributes_for(:host)
      expect(response.status).to eq(200)
    end
  end

  describe "POST　/api/host/sign_in" do
    let(:host) { create(:host) }
    it " email,passwordでログインできるか" do
      login
      expect(response.status).to eq(200)
    end
  end

  describe "DELETE /api/host/sign_out" do
    let(:host) { create(:host) }
    it "uid,client,access-tokenを送信するとログアウトできる" do
      login
      delete '/api/host/sign_out', headers: {
                                            uid: response.headers["uid"], 
                                            client: response.headers["client"], 
                                            "access-token": response.headers["access-token"]}
      expect(response.status).to eq(200)
    end

    it "headersがない場合ログアウトできない" do
      login
      delete '/api/host/sign_out'
      expect(response.status).to eq(404)
    end
  end

  def login
    post '/api/host/sign_in', params: {email: host.email, password: host.password }
  end
end


