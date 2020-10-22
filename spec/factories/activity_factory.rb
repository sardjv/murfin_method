# == Schema Information
#
# Table name: activities
#
#  id                 :bigint           not null, primary key
#  schedule           :mediumtext       not null
#  plan_id            :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :activity do
    schedule { 'abc' }
    plan_id { Plan.all.sample.try(:id) || create(:plan).id }
  end
end
