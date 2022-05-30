module GivingServices
  module Fees
    class FeeCalculatorService
      attr_reader :value, :kind, :currency

      def initialize(value:, kind:, currency:)
        @value = value
        @kind = kind
        @currency = currency
      end

      delegate :calculate_fee, to: :calculator_class_factory

      private

      def calculator_class_factory
        calculator_services[kind].new(value: value, currency: currency)
      end

      def calculator_services
        {
          stripe_card: Card::StripeCardFeeCalculatorService
        }
      end
    end
  end
end
