require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'POST /create' do
    subject(:request) { post '/api/v1/users', params: }

    context 'with right params' do
      let(:params) do
        {
          email: 'yan@ribon.io',
          language: 'en'
        }
      end

      it 'creates a new user in database' do
        expect { request }.to change(User, :count).by(1)
      end

      it 'heads http status created' do
        request

        expect(response).to have_http_status :created
      end

      it 'returns the user' do
        request

        expect_response_to_have_keys %w[created_at id email updated_at]
      end
    end

    context 'with wrong params' do
      let(:params) do
        {
          email: 'invalid_email'
        }
      end

      it 'does not create a new user in database' do
        expect { request }.not_to change(User, :count)
      end

      it 'heads http unprocessable_entity' do
        request

        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe 'POST /users/search' do
    subject(:request) { post '/api/v1/users/search', params: { email: user.email } }

    context 'when the user exists' do
      let(:user) { create(:user) }

      before { user }

      it 'heads http status ok' do
        request

        expect(response).to have_http_status :ok
      end

      it 'returns the user' do
        request

        expect_response_to_have_keys %w[created_at id email updated_at last_donation_at last_donated_cause]
      end
    end

    context 'when the user does not exist' do
      let(:user) { OpenStruct.new(email: 'nonexisting@user.com') }

      it 'heads http not found' do
        request

        expect(response).to have_http_status :not_found
      end

      it 'returns an error message' do
        request

        expect(response_body.error).to eq 'user not found'
      end
    end
  end

  describe 'POST /users/can_donate' do
    subject(:request) do
      post '/api/v1/users/can_donate', headers: { Email: user.email }, params: { integration_id: integration.id }
    end

    let(:integration) { create(:integration) }
    let(:user) { create(:user) }

    it 'returns the can_donate attribute' do
      request

      expect_response_to_have_keys %w[can_donate]
    end
  end

  describe 'GET /users/statistics' do
    subject(:request) do
      get "/api/v1/users/#{user.id}/statistics"
    end

    let(:user) { create(:user) }

    it 'returns the statistics' do
      request

      expect_response_to_have_keys %w[total_tickets total_donated total_non_profits total_causes]
    end
  end
end
