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
    days { ['monday'] }
    start_time { { 4 => '09', 5 => '00' } }
    end_time { { 4 => '13', 5 => '00' } }
    plan_id { Plan.all.sample.try(:id) || create(:plan).id }
  end
end
