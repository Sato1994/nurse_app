# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Host::HostNotices', type: :request do
  let(:headers) do
    { uid: response.headers['uid'], client: response.headers['client'],
      'access-token': response.headers['access-token'] }
  end

  describe 'DELETE /destroy' do
    let!(:host_notice) { create(:host_notice) }
    let!(:host_notice_2) { create(:host_notice) }

    it '自分のnoticeなら削除される' do
      post '/api/host/sign_in', params: { email: host_notice.host.email, password: host_notice.host.password }
      expect do
        delete "/api/host_notices/#{host_notice.id}", {
          headers: headers
        }
      end.to change(HostNotice, :count).to(1).from(2)
    end

    it '自分のnoticeでないならば削除されない' do
      post '/api/host/sign_in', params: { email: host_notice.host.email, password: host_notice.host.password }
      expect do
        delete "/api/host_notices/#{host_notice_2.id}", {
          headers: headers
        }
      end.not_to change(HostNotice, :count)
    end
  end
end
