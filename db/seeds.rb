# Create some dummy data for demonstration purposes.

# Create Users.
20.times { FactoryBot.create(:user) }

# Create TimeRangeTypes.
I18n.t('faker.time_range_type.name').each do |name|
  FactoryBot.create(:time_range_type, name: name)
end

# For each TimeRangeType,
# for each User,
# for each week of the year,
# create a TimeRange with a random value.
TimeRangeType.pluck(:id).each do |time_range_type_id|
  User.pluck(:id).each do |user_id|
    (1..51).each do |week|
      FactoryBot.create(
        :time_range,
        time_range_type_id: time_range_type_id,
        user_id: user_id,
        value: rand(1..100),
        start_time: DateTime.commercial(2020, week, 1),
        end_time: DateTime.commercial(2020, week, 1) + 1.week - 1.second
      )
    end
  end
end
