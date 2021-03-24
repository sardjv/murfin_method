# == Schema Information
#
# Table name: api_users
#
#  id                 :bigint           not null, primary key
#  name               :string(255)      not null
#  contact_email      :string(255)
#  created_by         :string(255)
#  token_generated_by :string(255)
#  token_sample       :string(255)
#  token_generated_at :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :api_user do
    name { Faker::Commerce.department }
    contact_email { Faker::Internet.unique.email }
  end
end
