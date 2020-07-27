# Create some dummy data for demonstration purposes.

# Create Bands 1, 2, 3, 4, 5, 6, 7, 8a, 8b, 8c, 8d, 9
band = FactoryBot.create(:group_type, name: 'Band')
(1..7).each do |band_number|
  FactoryBot.create(:user_group, group_type: band, name: "Band #{band_number}")
end
%w(a b c d).each do |band_8_letter|
  FactoryBot.create(:user_group, group_type: band, name: "Band 8#{band_8_letter}")
end
FactoryBot.create(:user_group, group_type: band, name: 'Band 9')

# Create Users
UserGroup.all.each do |band|
  2.times do
    user = FactoryBot.create(:user)
    FactoryBot.create(:membership, user_group: band, user: user)
  end
end

# Create TimeRangeTypes
plan_id = FactoryBot.create(:time_range_type, name: 'Job Plan').id
actuals_id = FactoryBot.create(:time_range_type, name: 'RIO Data').id

# For each User, create a static job plan and a set of seasonal actuals.
User.pluck(:id).each do |user_id|
  FakeGraphDataJob.perform_later(
    story: :static,
    user_id: user_id,
    time_range_type_id: plan_id,
    start: DateTime.now.beginning_of_year,
    volatility: 0.05 # 5% weekly variation
  )

  FakeGraphDataJob.perform_later(
    story: :seasonal_summer_and_christmas,
    user_id: user_id,
    time_range_type_id: actuals_id,
    start: DateTime.now.beginning_of_year,
    volatility: 0.5  # 50% seasonal variation
  )
end
