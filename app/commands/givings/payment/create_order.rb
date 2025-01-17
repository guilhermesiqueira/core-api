# frozen_string_literal: true

module Givings
  module Payment
    class CreateOrder < ApplicationCommand
      prepend SimpleCommand

      attr_reader :klass

      def initialize(klass, args)
        @klass = klass.new(args)
      end

      def call
        order = klass.generate_order

        payment_process_result = klass.process_payment(order)

        success_callback(order, payment_process_result)

        RecursiveOpenStruct.new(payment_process_result.merge({ payment: order.payment }))
      rescue StandardError => e
        failure_callback(order, e)
        Reporter.log(error: e, extra: { message: e.message }, level: :fatal)
        errors.add(:message, e.message)
      end

      private

      def success_callback(order, result)
        return unless result

        status = ::Payment::Gateways::Stripe::Helpers.status(result[:status])
        update_success(order:, status:, result:)
        return unless status == :paid

        handle_contribution_creation(order.payment)
        klass.success_callback(order, result)
      end

      def failure_callback(order, err)
        status = case err.type
                 when 'requires_action'
                   :requires_action
                 when 'blocked'
                   :blocked
                 else
                   :failed
                 end
        update_failed(order:, err:, status:)
      end

      def update_success(order:, status:, result:)
        order.payment.update(status:)
        update_external_ids(order:, result:)
      end

      def update_failed(order:, err:, status:)
        order.payment.update(status:, error_code: err.code)
        order.payment&.subscription&.update(status: :inactive)
        order.payment&.subscription&.update(external_id: err.subscription_id) if err.subscription_id
        order.payment.update(external_id: err.external_id) if err.external_id
      end

      def handle_contribution_creation(payment)
        PersonPayments::CreateContributionJob.perform_later(payment)
      end

      def update_external_ids(order:, result:)
        external_id = result[:external_id]
        external_subscription_id = result[:external_subscription_id]
        external_invoice_id = result[:external_invoice_id]

        order.payment.update(external_id:) if external_id
        order.payment.update(external_invoice_id:) if external_invoice_id
        order.payment&.subscription&.update(external_id: external_subscription_id) if external_subscription_id
      end
    end
  end
end
