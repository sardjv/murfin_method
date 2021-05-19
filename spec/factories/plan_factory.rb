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
    user_id { User.all.sample.try(:id) || create(:user).id }

    after(:build) do |plan|
      unless plan.start_date && plan.end_date
        plan.start_date = Faker::Date.between(from: Time.zone.today - 1.year, to: Time.zone.today + 1.year).beginning_of_month
        plan.end_date = (plan.start_date + 11.months).end_of_month
      end
    end
  end
end
