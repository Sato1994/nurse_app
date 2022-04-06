# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::UserNotices', type: :request do
  let(:headers) do
    { uid: response.headers['uid'], client: response.headers['client'],
      'access-token': response.headers['access-token'] }
  end

  describe 'DELETE /destroy' do
    let!(:user_notice) { create(:user_notice) }
    let!(:user_notice_2) { create(:user_notice) }

    it '自分のnoticeなら削除される' do
      post '/api/user/sign_in', params: { email: user_notice.user.email, password: user_notice.user.password }
      expect do
        delete "/api/user_notices/#{user_notice.id}", {
          headers: headers
        }
      end.to change(UserNotice, :count).to(1).from(2)
    end

    it '自分のnoticeでないならば削除されない' do
      post '/api/user/sign_in', params: { email: user_notice.user.email, password: user_notice.user.password }
      expect do
        delete "/api/user_notices/#{user_notice_2.id}", {
          headers: headers
        }
      end.not_to change(UserNotice, :count)
    end
  end
end
