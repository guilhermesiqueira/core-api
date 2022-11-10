class OfferManagerBlueprint < Blueprinter::Base
  identifier :id

  fields :currency, :subscription, :price_cents, :price_value, :active, :title, :position_order,
         :external_id, :gateway, :created_at, :updated_at

  field :price do |object|
    Money.new(object.price_cents, object.currency).format
  end
end
