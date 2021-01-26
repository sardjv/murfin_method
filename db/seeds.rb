# Create some dummy data for demonstration purposes.

# RiO TimeRangeType
actuals_id = FactoryBot.create(:time_range_type, name: 'RIO Data').id

# Tags for plan activities and RiO data
category_tag_type = FactoryBot.create(:tag_type, name: 'Category',
                                                 active_for_time_ranges: true,
                                                 active_for_activities: true)
subcategory_tag_type = FactoryBot.create(:tag_type, name: 'Subcategory',
                                                    parent: category_tag_type,
                                                    active_for_time_ranges: true,
                                                    active_for_activities: true)

# DCC
dcc_tag = FactoryBot.create(:tag, name: 'DCC (Direct Clinical Care)', tag_type: category_tag_type)
FactoryBot.create(:tag, tag_type: subcategory_tag_type, parent: dcc_tag, name: 'Care Co-ordination')
FactoryBot.create(:tag, tag_type: subcategory_tag_type, parent: dcc_tag, name: 'Care Intervention Network')
FactoryBot.create(:tag, tag_type: subcategory_tag_type, parent: dcc_tag, name: 'CBT / Psychology Treatments')
FactoryBot.create(:tag, tag_type: subcategory_tag_type, parent: dcc_tag, name: 'Psychotherapy Treatments')
FactoryBot.create(:tag, tag_type: subcategory_tag_type, parent: dcc_tag, name: 'Family Therapy Treatments')
FactoryBot.create(:tag, tag_type: subcategory_tag_type, parent: dcc_tag, name: 'Psychiatry Treatment')
FactoryBot.create(:tag, tag_type: subcategory_tag_type, parent: dcc_tag, name: 'Initial Assessmet')
FactoryBot.create(:tag, tag_type: subcategory_tag_type, parent: dcc_tag, name: 'All Pathways')

# SPA
spa_tag = FactoryBot.create(:tag, name: 'SPA (Supporting Professional Activities)', tag_type: category_tag_type)
FactoryBot.create(:tag, tag_type: subcategory_tag_type, parent: spa_tag, name: 'Team Meetings')
FactoryBot.create(:tag, tag_type: subcategory_tag_type, parent: spa_tag, name: 'Supervisions')
FactoryBot.create(:tag, tag_type: subcategory_tag_type, parent: spa_tag, name: 'Admin tasks')
FactoryBot.create(:tag, tag_type: subcategory_tag_type, parent: spa_tag, name: 'Not Known')

# Plan Data Tags
outcomed_tag_type = FactoryBot.create(:tag_type, name: 'Outcomed on RiO',
                                                 active_for_activities: true,
                                                 active_for_time_ranges: false)

FactoryBot.create(:tag, tag_type: outcomed_tag_type, name: 'Yes', default_for_filter: true)
FactoryBot.create(:tag, tag_type: outcomed_tag_type, name: 'No')

# Actual Data Tags
rio_tag_type = FactoryBot.create(:tag_type, name: 'RiO Type',
                                            active_for_activities: false,
                                            active_for_time_ranges: true)
FactoryBot.create(:tag, tag_type: rio_tag_type, name: 'Attended', default_for_filter: true)
FactoryBot.create(:tag, tag_type: rio_tag_type, name: 'DNA')
FactoryBot.create(:tag, tag_type: rio_tag_type, name: 'Provider Cancelled')
FactoryBot.create(:tag, tag_type: rio_tag_type, name: 'Client Cancelled')
FactoryBot.create(:tag, tag_type: rio_tag_type, name: 'Unoutcomed')

no_patients_tag_type = FactoryBot.create(:tag_type, name: 'Number of Patients',
                                                    active_for_activities: false,
                                                    active_for_time_ranges: true)
(1..10).each do |number|
  FactoryBot.create(:tag, tag_type: no_patients_tag_type, name: number)
end

# User Groups

# Bands 1, 2, 3, 4, 5, 6, 7, 8a, 8b, 8c, 8d, 9
band = FactoryBot.create(:group_type, name: 'Band')
(1..7).each do |band_number|
  FactoryBot.create(:user_group, group_type: band, name: "Band #{band_number}")
end
%w[a b c d].each do |band_8_letter|
  FactoryBot.create(:user_group, group_type: band, name: "Band 8#{band_8_letter}")
end
FactoryBot.create(:user_group, group_type: band, name: 'Band 9')

# Demo team
team_group_type = FactoryBot.create(:group_type, name: 'Team')
team = FactoryBot.create(:user_group, group_type: team_group_type, name: 'CAHMS')
# Team Lead
reta = FactoryBot.create(:user, first_name: 'Reta', last_name: 'Lang', email: 'reta@example.com')
FactoryBot.create(:membership, user_group: team, user: reta, role: 1)
# Team Members
roger = FactoryBot.create(:user, first_name: 'Rodger', last_name: 'Steuber', email: 'rodger@example.com')
roger.user_groups << team

10.times do
  user = FactoryBot.create(:user)
  user.user_groups << band.user_groups.sample
  user.user_groups << team
end

# For each User, create a static job plan and a set of seasonal actuals.
team.users.pluck(:id).each do |user_id|
  FactoryBot.create(:plan, user_id: user_id,
                           start_date: DateTime.now.beginning_of_year - 1.year,
                           end_date: DateTime.now.end_of_year - 1.year,
                           activities: FactoryBot.create_list(:activity, 5))

  FakeGraphDataJob.perform_now(
    story: :seasonal_summer_and_christmas,
    user_id: user_id,
    time_range_type_id: actuals_id,
    start: DateTime.now.beginning_of_year - 1.year,
    volatility: 0.9 # 90% seasonal variation
  )
end

def weighted_sample(array, value, weight)
  weight.times { array.push(value) }
  array.sample
end

Activity.includes(:tags).each do |a|
  subcat_tag = subcategory_tag_type.tags.to_a.push(nil).sample
  next unless subcat_tag

  # Category
  a.tag_associations.create(tag_id: subcat_tag.parent.id, tag_type_id: subcat_tag.parent.tag_type.id) if subcat_tag
  # Subcategory
  a.tag_associations.create(tag_id: subcat_tag.id, tag_type_id: subcat_tag.tag_type.id) if subcat_tag

  if subcat_tag.parent == dcc_tag
    # Outcomed on RiO, Yes, No or None if DCC
    yes_tag = outcomed_tag_type.tags.find_by(name: 'Yes')
    outcomed_tag = weighted_sample(outcomed_tag_type.tags.to_a.push(nil), yes_tag, 5)
    a.tag_associations.create(tag_id: outcomed_tag.id, tag_type_id: outcomed_tag.tag_type.id) if outcomed_tag
  end
  next if subcat_tag.parent == dcc_tag

  # Outcomed on RiO, No if SPA
  outcomed_tag = outcomed_tag_type.tags.last
  a.tag_associations.create(tag_id: outcomed_tag.id, tag_type_id: outcomed_tag.tag_type.id)
end

TimeRange.includes(:tags).each do |tr|
  cat_tag = dcc_tag.children.to_a.push(nil).sample
  # DCC
  tr.tag_associations.create(tag_id: cat_tag.parent.id, tag_type_id: cat_tag.parent.tag_type.id) if cat_tag
  # DCC Subcategory
  tr.tag_associations.create(tag_id: cat_tag.id, tag_type_id: cat_tag.tag_type.id) if cat_tag

  # Number of Patients
  no_one_tag = no_patients_tag_type.tags.find_by(name: '1')
  no_tag = weighted_sample(no_patients_tag_type.tags.to_a.push(nil), no_one_tag, 10)
  tr.tag_associations.create(tag_id: no_tag.id, tag_type_id: no_tag.tag_type.id) if no_tag

  # RiO Type
  attended_tag = rio_tag_type.tags.find_by(name: 'Attended')
  rio_tag = weighted_sample(rio_tag_type.tags.to_a.push(nil), attended_tag, 5)
  tr.tag_associations.create(tag_id: rio_tag.id, tag_type_id: rio_tag.tag_type.id) if rio_tag
end
