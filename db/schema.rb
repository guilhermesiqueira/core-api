# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_09_27_130824) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "api_keys", force: :cascade do |t|
    t.string "bearer_type", null: false
    t.bigint "bearer_id", null: false
    t.string "token_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bearer_type", "bearer_id"], name: "index_api_keys_on_bearer"
  end

  create_table "badges_sashes", force: :cascade do |t|
    t.integer "badge_id"
    t.integer "sash_id"
    t.boolean "notified_user", default: false
    t.datetime "created_at"
    t.index ["badge_id", "sash_id"], name: "index_badges_sashes_on_badge_id_and_sash_id"
    t.index ["badge_id"], name: "index_badges_sashes_on_badge_id"
    t.index ["sash_id"], name: "index_badges_sashes_on_sash_id"
  end

  create_table "causes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chains", force: :cascade do |t|
    t.string "name"
    t.string "ribon_contract_address"
    t.string "donation_token_contract_address"
    t.integer "chain_id"
    t.string "rpc_url"
    t.string "node_url"
    t.string "symbol_name"
    t.string "currency_name"
    t.string "block_explorer_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gas_fee_url"
    t.string "default_donation_pool_address"
  end

  create_table "customers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id"
    t.string "name", null: false
    t.string "email", null: false
    t.jsonb "customer_keys", default: {}
    t.string "tax_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "person_id"
    t.index ["person_id"], name: "index_customers_on_person_id"
    t.index ["user_id"], name: "index_customers_on_user_id", unique: true
  end

  create_table "donation_blockchain_transactions", force: :cascade do |t|
    t.bigint "donation_id", null: false
    t.bigint "chain_id", null: false
    t.string "transaction_hash"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chain_id"], name: "index_donation_blockchain_transactions_on_chain_id"
    t.index ["donation_id"], name: "index_donation_blockchain_transactions_on_donation_id"
  end

  create_table "donations", force: :cascade do |t|
    t.bigint "non_profit_id", null: false
    t.bigint "integration_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.decimal "value"
    t.index ["integration_id"], name: "index_donations_on_integration_id"
    t.index ["non_profit_id"], name: "index_donations_on_non_profit_id"
    t.index ["user_id"], name: "index_donations_on_user_id"
  end

  create_table "guests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "wallet_address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "person_id"
    t.index ["person_id"], name: "index_guests_on_person_id"
  end

  create_table "integration_pools", force: :cascade do |t|
    t.bigint "integration_id", null: false
    t.bigint "pool_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["integration_id"], name: "index_integration_pools_on_integration_id"
    t.index ["pool_id"], name: "index_integration_pools_on_pool_id"
  end

  create_table "integrations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "unique_address", default: -> { "gen_random_uuid()" }, null: false
    t.integer "ticket_availability_in_minutes"
    t.integer "status", default: 0
  end

  create_table "merit_actions", force: :cascade do |t|
    t.integer "user_id"
    t.string "action_method"
    t.integer "action_value"
    t.boolean "had_errors", default: false
    t.string "target_model"
    t.integer "target_id"
    t.text "target_data"
    t.boolean "processed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["processed"], name: "index_merit_actions_on_processed"
  end

  create_table "merit_activity_logs", force: :cascade do |t|
    t.integer "action_id"
    t.string "related_change_type"
    t.integer "related_change_id"
    t.string "description"
    t.datetime "created_at"
  end

  create_table "merit_score_points", force: :cascade do |t|
    t.bigint "score_id"
    t.bigint "num_points", default: 0
    t.string "log"
    t.datetime "created_at"
    t.index ["score_id"], name: "index_merit_score_points_on_score_id"
  end

  create_table "merit_scores", force: :cascade do |t|
    t.bigint "sash_id"
    t.string "category", default: "default"
    t.index ["sash_id"], name: "index_merit_scores_on_sash_id"
  end

  create_table "mobility_string_translations", force: :cascade do |t|
    t.string "locale", null: false
    t.string "key", null: false
    t.string "value"
    t.string "translatable_type"
    t.bigint "translatable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_string_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_string_translations_on_keys", unique: true
    t.index ["translatable_type", "key", "value", "locale"], name: "index_mobility_string_translations_on_query_keys"
  end

  create_table "mobility_text_translations", force: :cascade do |t|
    t.string "locale", null: false
    t.string "key", null: false
    t.text "value"
    t.string "translatable_type"
    t.bigint "translatable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_text_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_text_translations_on_keys", unique: true
  end

  create_table "non_profit_impacts", force: :cascade do |t|
    t.bigint "non_profit_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.decimal "usd_cents_to_one_impact_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["non_profit_id"], name: "index_non_profit_impacts_on_non_profit_id"
  end

  create_table "non_profit_pools", force: :cascade do |t|
    t.bigint "non_profit_id", null: false
    t.bigint "pool_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["non_profit_id"], name: "index_non_profit_pools_on_non_profit_id"
    t.index ["pool_id"], name: "index_non_profit_pools_on_pool_id"
  end

  create_table "non_profits", force: :cascade do |t|
    t.string "name"
    t.text "impact_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.bigint "cause_id"
    t.index ["cause_id"], name: "index_non_profits_on_cause_id"
  end

  create_table "offer_gateways", force: :cascade do |t|
    t.bigint "offer_id", null: false
    t.string "external_id"
    t.integer "gateway"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offer_id"], name: "index_offer_gateways_on_offer_id"
  end

  create_table "offers", force: :cascade do |t|
    t.integer "currency"
    t.integer "price_cents"
    t.boolean "subscription"
    t.boolean "active"
    t.integer "position_order"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "person_blockchain_transactions", force: :cascade do |t|
    t.integer "treasure_entry_status", default: 0
    t.string "transaction_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "person_payment_id"
    t.index ["person_payment_id"], name: "index_person_blockchain_transactions_on_person_payment_id"
  end

  create_table "person_payment_fees", force: :cascade do |t|
    t.integer "card_fee_cents"
    t.integer "crypto_fee_cents"
    t.bigint "person_payment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_payment_id"], name: "index_person_payment_fees_on_person_payment_id"
  end

  create_table "person_payments", force: :cascade do |t|
    t.datetime "paid_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "offer_id"
    t.integer "amount_cents"
    t.uuid "person_id"
    t.integer "status", default: 0
    t.integer "payment_method"
    t.index ["offer_id"], name: "index_person_payments_on_offer_id"
    t.index ["person_id"], name: "index_person_payments_on_person_id"
  end

  create_table "pools", force: :cascade do |t|
    t.string "address"
    t.bigint "token_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token_id"], name: "index_pools_on_token_id"
  end

  create_table "ribon_configs", force: :cascade do |t|
    t.decimal "default_ticket_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "minimum_integration_amount"
    t.integer "default_chain_id"
  end

  create_table "sashes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sources", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "integration_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["integration_id"], name: "index_sources_on_integration_id"
    t.index ["user_id"], name: "index_sources_on_user_id"
  end

  create_table "stories", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "non_profit_id", null: false
    t.integer "position"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["non_profit_id"], name: "index_stories_on_non_profit_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.integer "decimals"
    t.bigint "chain_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chain_id"], name: "index_tokens_on_chain_id"
  end

  create_table "user_donation_stats", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "last_donation_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_donation_stats_on_user_id"
  end

  create_table "user_managers", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_user_managers_on_confirmation_token", unique: true
    t.index ["email"], name: "index_user_managers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_user_managers_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_user_managers_on_uid_and_provider", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sash_id"
    t.integer "level", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.string "public_key"
    t.string "encrypted_private_key"
    t.string "private_key_iv"
    t.integer "status"
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_wallets_on_owner"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "customers", "people"
  add_foreign_key "donation_blockchain_transactions", "chains"
  add_foreign_key "donation_blockchain_transactions", "donations"
  add_foreign_key "donations", "integrations"
  add_foreign_key "donations", "non_profits"
  add_foreign_key "donations", "users"
  add_foreign_key "integration_pools", "integrations"
  add_foreign_key "integration_pools", "pools"
  add_foreign_key "non_profit_impacts", "non_profits"
  add_foreign_key "non_profit_pools", "non_profits"
  add_foreign_key "non_profit_pools", "pools"
  add_foreign_key "non_profits", "causes"
  add_foreign_key "offer_gateways", "offers"
  add_foreign_key "person_blockchain_transactions", "person_payments"
  add_foreign_key "person_payment_fees", "person_payments"
  add_foreign_key "person_payments", "offers"
  add_foreign_key "person_payments", "people"
  add_foreign_key "pools", "tokens"
  add_foreign_key "stories", "non_profits"
  add_foreign_key "user_donation_stats", "users"
end
