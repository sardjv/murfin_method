# == Schema Information
#
# Table name: activities
#
#  id         :bigint           not null, primary key
#  schedule   :text(16777215)   not null
#  plan_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :activity do
    seconds_per_week { 4 * 60 * 60 }
    plan_id { Plan.all.sample.try(:id) || create(:plan).id }
  end
end
