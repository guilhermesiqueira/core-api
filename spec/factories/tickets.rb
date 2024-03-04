# == Schema Information
#
# Table name: tickets
#
#  id             :bigint           not null, primary key
#  category       :integer          default("daily")
#  platform       :string
#  source         :integer          default("integration")
#  status         :integer          default("collected")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  external_id    :string
#  integration_id :bigint           not null
#  user_id        :bigint           not null
#
FactoryBot.define do
  factory :ticket do
    user { build(:user) }
    external_id { 'MyString' }
    integration { build(:integration) }
  end
end
