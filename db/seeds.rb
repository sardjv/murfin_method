# Create some dummy data for demonstration purposes.

# Create Users.
10.times { FactoryBot.create(:user) }

# Create TimeRangeTypes
plan_id = FactoryBot.create(:time_range_type, name: 'Job Plan').id
actuals_id = FactoryBot.create(:time_range_type, name: 'RIO Data').id

# For each User, create a static job plan and a set of seasonal actuals.
User.pluck(:id).each do |user_id|
  FakeGraphDataJob.perform_later(
    story: :static,
    user_id: user_id,
    time_range_type_id: plan_id,
    graph_start_time: DateTime.now.beginning_of_year,
    graph_end_time: DateTime.now.end_of_year,
    unit: :week,
    volatility: 0.05 # 5% weekly variation
  )

  FakeGraphDataJob.perform_later(
    story: :seasonal_summer_and_christmas,
    user_id: user_id,
    time_range_type_id: actuals_id,
    graph_start_time: DateTime.now.beginning_of_year,
    graph_end_time: DateTime.now.end_of_year,
    unit: :week,
    volatility: 0.5  # 50% seasonal variation
  )
end
