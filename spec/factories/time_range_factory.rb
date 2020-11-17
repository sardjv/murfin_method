# == Schema Information
#
# Table name: time_ranges
#
#  id                 :bigint           not null, primary key
#  start_time         :datetime         not null
#  end_time           :datetime         not null
#  value              :integer          not null
#  time_range_type_id :bigint           not null
#  user_id            :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :time_range do
    start_time { Faker::Time.between(from: DateTime.now - 1.year, to: DateTime.now + 1.year) }
    value { Faker::Number.decimal(l_digits: 2) }
    time_range_type_id { TimeRangeType.all.sample.try(:id) || create(:time_range_type).id }
    user_id { User.all.sample.try(:id) || create(:user).id }

    after(:build) do |time_range|
      # Set end_time to be after start_time.
      time_range.end_time = time_range.start_time + 1.week - 1.second unless time_range.end_time
    end
  end
end
