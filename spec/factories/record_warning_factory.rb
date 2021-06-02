# == Schema Information
#
# Table name: record_warnings
#
#  id            :bigint           not null, primary key
#  warnable_id   :integer
#  warnable_type :string(255)
#  key           :string(255)
#  data          :json
#  expires_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :record_warning do
    association :warnable, factory: :plan
    key { Faker::Lorem.words(number: 3).join('_') }

    trait :exceed_max_working_hours_per_week do
      warnable { create(:plan) }
      key { 'exceed_max_working_hours_per_week' }
      data do
        {
          plan_working_hours_per_week: 37.5,
          actual_working_hours_per_week: 38,
          week_start_date: 1.week.ago,
        }
      end
    end
  end
end
