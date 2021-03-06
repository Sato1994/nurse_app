# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::User::UserMessages', type: :request do
  let(:headers) do
    { uid: response.headers['uid'], client: response.headers['client'],
      'access-token': response.headers['access-token'] }
  end

  describe 'POST /create' do
    it 'ログインしていなければ失敗' do
      room = create(:room)
      post "/api/user_messages", params: { message: 'こんにちは', room_id: room.id }
      expect(UserMessage.count).to eq(0)
    end

    it '適切な数のjsonを返す' do
      room = create(:room)
      post '/api/user/sign_in', params: { email: room.user.email, password: room.user.password }
      post "/api/user_messages", params: { message: 'こんにちは', room_id: room.id }, headers: headers
      json = JSON.parse(response.body)
      expect(json['user_message'].count).to eq(2)
    end
  end
end
