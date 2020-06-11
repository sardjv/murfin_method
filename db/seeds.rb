# Create some dummy data for demonstration purposes.

# Create Users.
20.times { FactoryBot.create(:user) }

# Create TimeRangeTypes.
I18n.t('faker.time_range_type.name').each do |name|
  FactoryBot.create(:time_range_type, name: name)
end

# From: https://stackoverflow.com/questions/8597731/are-there-known-techniques-to-generate-realistic-looking-fake-stock-data
# Adjust a value according to a given volatility between 0 and 1.0.
def adjust(old_value, volatility)
  rnd = rand() # generate number, 0 <= x < 1.0
  change_percent = 2 * volatility * rnd
  if (change_percent > volatility)
    change_percent -= (2 * volatility)
  end
  change_amount = old_value * change_percent
  new_value = old_value + change_amount
  new_value.round
end

# For each TimeRangeType,
# for each User,
# for each week of the year,
# create a TimeRange with a random value.
TimeRangeType.pluck(:id).each do |time_range_type_id|
  User.pluck(:id).each do |user_id|
    old_value = rand(1..100) # Value of first week
    volatility = rand(0.02..0.6) # Between 2% and 60% volatility, week to week.
    (1..51).each do |week|
      FactoryBot.create(
        :time_range,
        time_range_type_id: time_range_type_id,
        user_id: user_id,
        value: old_value,
        start_time: DateTime.commercial(2020, week, 1),
        end_time: DateTime.commercial(2020, week, 1) + 1.week - 1.second
      )
      old_value = adjust(old_value, volatility)
    end
  end
end

