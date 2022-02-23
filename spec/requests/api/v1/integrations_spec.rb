require 'rails_helper'

RSpec.describe 'Api::V1::Integrations', type: :request do
  describe 'GET /show' do
    subject(:request) { get "/api/v1/integrations/#{integration.id}" }

    let(:integration) { create(:integration) }

    it 'returns a list of non profits' do
      request

      expect_response_to_have_keys(%w[created_at id updated_at logo name url wallet_address])
    end
  end
end