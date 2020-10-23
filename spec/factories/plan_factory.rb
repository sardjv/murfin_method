# == Schema Information
#
# Table name: plans
#
#  id         :bigint           not null, primary key
#  start_date :date             not null
#  end_date   :date             not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :plan do
    start_date { Faker::Date.between(from: Date.today - 1.year, to: Date.today + 1.year) }
    user_id { User.all.sample.try(:id) || create(:user).id }

    after(:build) do |plan|
      # Set end_date to be after start_date.
      plan.end_date = plan.start_date + 1.week unless plan.end_date
    end
  end
end
