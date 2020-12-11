# == Schema Information
#
# Table name: signoffs
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  plan_id    :bigint           not null
#  signed_at  :datetime
#  revoked_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :signoff do
    user_id { User.all.sample.try(:id) || create(:user).id }
    plan_id { Plan.all.sample.try(:id) || create(:plan).id }
  end
end
