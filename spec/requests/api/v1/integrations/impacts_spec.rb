require 'rails_helper'

RSpec.describe 'Api::V1::Integrations::Impacts', type: :request do
  describe 'GET /index' do
    subject(:request) { get "/api/v1/integrations/#{id}/impacts" }

    let(:id) { create(:integration).unique_address }

    let(:impact) do
      { total_donations: 10, total_donors: 5,
        impact_per_non_profit: [{ non_profit:, impact: 350 }] }
    end
    let(:impact_service_instance) { instance_double(Service::Integrations::Impact, formatted_impact: impact) }
    let(:non_profit) { build(:non_profit) }

    before do
      allow(Service::Integrations::Impact).to receive(:new).and_return(impact_service_instance)
    end

    it 'returns the required keys' do
      request

      expect_response_to_have_keys(%w[total_donations total_donors impact_per_non_profit])
    end
  end
end