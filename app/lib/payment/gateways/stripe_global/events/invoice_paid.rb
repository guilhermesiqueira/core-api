module Payment
  module Gateways
    module StripeGlobal
      module Events
        class InvoicePaid < Base
          attr_reader :subscription, :data, :payment

          def handle(event)
            @data = event.data.object
            @subscription = Subscription.find_by(external_id: data['subscription'])
            return unless subscription

            subscription.update(status: :active)

            set_next_payment
            upsert_payment
            handle_contribution_creation
            handle_giving_to_blockchain
          end

          private

          def set_next_payment
            invoice = Entities::Invoice.upcoming(customer: data['customer'])
            return unless invoice

            next_payment_attempt = Time.zone.at(invoice.next_payment_attempt)
            subscription.update(next_payment_attempt:)
          end

          # rubocop:disable Metrics/AbcSize
          def set_payment_attributes
            payment.paid_date = Time.zone.at(data['created'])
            payment.amount_cents = data['amount_paid']
            payment.external_id = data['payment_intent']
            payment.payment_method = subscription.payment_method
            payment.offer = subscription.offer
            payment.receiver = receiver_person_payment
            payment.payer = subscription.payer
            payment.platform = subscription.platform
            payment.integration = subscription.integration
            payment.status = :paid
          end
          # rubocop:enable Metrics/AbcSize

          def receiver_person_payment
            return Cause.where(status: :active).sample if subscription.category == 'club'

            subscription.receiver
          end

          def upsert_payment
            external_invoice_id = data['id']
            @payment = PersonPayment.where(subscription:, external_invoice_id:).first_or_initialize
            set_payment_attributes
            payment.save!
          end

          def handle_giving_to_blockchain
            return if payment.person_blockchain_transaction&.success?

            return call_add_cause_giving_blockchain_job if payment.receiver_type == 'Cause'

            call_add_non_profit_giving_blockchain_job
          end

          def handle_contribution_creation
            return if payment.contribution.present?

            PersonPayments::CreateContributionJob.perform_later(payment)
          end

          def call_add_cause_giving_blockchain_job
            Givings::Payment::AddGivingCauseToBlockchainJob
              .perform_later(amount: payment.crypto_amount, payment:,
                             pool: payment.receiver&.default_pool)
          end

          def call_add_non_profit_giving_blockchain_job
            Givings::Payment::AddGivingNonProfitToBlockchainJob
              .perform_later(non_profit: payment.receiver,
                             amount: payment.crypto_amount, payment:)
          end
        end
      end
    end
  end
end
