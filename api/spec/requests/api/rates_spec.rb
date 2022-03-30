# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::Rates', type: :request do
  let(:headers) do
    { uid: response.headers['uid'], client: response.headers['client'],
      'access-token': response.headers['access-token'] }
  end

  describe 'POST /create' do
    let(:agreement) { create(:agreement, state: 2) }
    let(:post_rates) { post '/api/rates', params: { agreement_id: agreement.id, star: 1, comment: 'こんにちは' }, headers: headers }

    context '適切なユーザーでログイン' do
      it 'agreementのstateが2(finished)ならば作成できる' do
        post '/api/user/sign_in', params: { email: agreement.user.email, password: agreement.user.password }
        expect do
          post_rates
        end.to change(Rate, :count).from(0).to(1)
      end

      it '作成したら期待するmessageを返す' do
        post '/api/user/sign_in', params: { email: agreement.user.email, password: agreement.user.password }
        post_rates
        expect(response.body).to include('勤務お疲れさまでした。')
      end

      it 'agreementのstateが2以外ならば期待するmessageを返す' do
        agreement = create(:agreement, state: 1)
        post '/api/user/sign_in', params: { email: agreement.user.email, password: agreement.user.password }
        post '/api/rates', params: { agreement_id: agreement.id, star: 1, comment: 'こんにちは' }, headers: headers
        expect(response.body).to include('勤務終了までは評価できません。')
      end
    end

    context '不適切なユーザーでログイン' do
      it '適切なuserでログインしていなければsutate Unauthorized(401)を返す' do
        user = create(:user)
        post '/api/user/sign_in', params: { email: user.email, password: user.password }
        post_rates
        expect(response.status).to eq(401)
      end

      it '適切なuserでログインしていなければ期待するmessageを返す' do
        user = create(:user)
        post '/api/user/sign_in', params: { email: user.email, password: user.password }
        post_rates
        expect(response.body).to include('適切なユーザーでログインしてください。')
      end

      it '適切なuserでログインしていなければ作成されない' do
        user = create(:user)
        post '/api/user/sign_in', params: { email: user.email, password: user.password }
        expect do
          post_rates
        end.not_to change(Rate, :count)
      end
    end
  end
end
