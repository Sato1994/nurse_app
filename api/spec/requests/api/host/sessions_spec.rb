# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Host::Sessions', type: :request do
  let(:json) { JSON.parse(response.body) }

  describe 'POST /api/host/sign_in' do
    let(:host) { create(:host) }

    context 'ログイン成功' do
      it '期待する数のプロパティを返す' do
        post '/api/host/sign_in', params: { email: host.email, password: host.password }
        expect(json.count).to eq(8)
      end
    end

    context 'ログイン失敗' do
      it 'status401(unauthorized) を返す' do
        post '/api/host/sign_in', params: { email: 'mochi@mmugi.com', password: 'mochimugi' }
        expect(response.status).to eq(401)
      end
    end
  end
end
