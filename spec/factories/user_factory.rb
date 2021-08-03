# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  first_name             :string(255)      not null
#  last_name              :string(255)      not null
#  email                  :string(255)      not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  admin                  :boolean          default(FALSE), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  epr_uuid               :string(255)
#  ldap                   :text(65535)
#
FactoryBot.define do
  factory :user do
    first_name { Faker::Name.unique.first_name }
    last_name  { Faker::Name.unique.last_name }
    email { Faker::Internet.unique.email }
    skip_password_validation { true }
    epr_uuid { Faker::Internet.uuid }
  end

  factory(:admin, parent: :user) do
    admin { true }
  end

  trait :with_password do
    skip_password_validation { false }
    password { '12345678' }
  end
end
