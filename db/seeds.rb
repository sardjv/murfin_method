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

# Create TimeRangeTypes
plan_id = FactoryBot.create(:time_range_type, name: 'Job Plan').id
actuals_id = FactoryBot.create(:time_range_type, name: 'RIO Data').id

# Health Visitors Team
team = FactoryBot.create(:group_type, name: 'Team')
health_visitors = FactoryBot.create(:user_group, group_type: team, name: "Health Visitors")
# Team Lead
manager = FactoryBot.create(:user, first_name: 'Reta', last_name: 'Lang', email: 'reta@example.com')
FactoryBot.create(:membership, user_group: health_visitors, user: manager, role: 1)
# Team Members
user = FactoryBot.create(:user, first_name: 'Rodger', last_name: 'Steuber', email: 'rodger@example.com')
FactoryBot.create(:membership, user_group: health_visitors, user: user)
10.times do
  user = FactoryBot.create(:user)
  user.user_groups << band.user_groups.sample
  FactoryBot.create(:membership, user_group: health_visitors, user: user)
end
# Admin
user = FactoryBot.create(:user, first_name: 'Bella', last_name: 'Owen', email: 'bella@example.com', admin: true)

# For each User, create a static job plan and a set of seasonal actuals.
health_visitors.users.pluck(:id).each do |user_id|
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
