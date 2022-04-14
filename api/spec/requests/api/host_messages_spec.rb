# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::HostMessages', type: :request do
  let(:headers) do
    { uid: response.headers['uid'], client: response.headers['client'],
      'access-token': response.headers['access-token'] }
  end

  describe 'POST /create' do
    it 'ログインしていなければ失敗' do
      room = create(:room)
      post "/api/host_messages/#{room.id}", params: { message: 'こんにちは' }
      expect(HostMessage.count).to eq(0)
    end

    it '適切な数のjsonを返す' do
      room = create(:room)
      post '/api/host/sign_in', params: { email: room.host.email, password: room.host.password }
      post "/api/host_messages/#{room.id}", params: { message: 'こんにちは' }, headers: headers
      json = JSON.parse(response.body)
      expect(json['host_message'].count).to eq(2)
    end
  end
end
