# == Schema Information
#
# Table name: plans
#
#  id                 :bigint           not null, primary key
#  start_time         :datetime         not null
#  end_time           :datetime         not null
#  user_id            :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :plan do
    start_time { Faker::Time.between(from: DateTime.now - 1.year, to: DateTime.now + 1.year) }
    user_id { User.all.sample.try(:id) || create(:user).id }

    after(:build) do |plan|
      # Set end_time to be after start_time.
      plan.end_time = plan.start_time + 1.week - 1.second unless plan.end_time
    end
  end
end
