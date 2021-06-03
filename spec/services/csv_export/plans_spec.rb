describe CsvExport::Plans do
  subject { described_class.call(args) }
  let(:args) { { plans: Plan.all } }

  let!(:tag_type1) { create :tag_type, name: 'Category' }
  let!(:tag1a) { create :tag, name: 'DCC', tag_type: tag_type1 }
  let!(:tag1b) { create :tag, name: 'SPA', tag_type: tag_type1 }

  let!(:tag_type2) { create :tag_type, name: 'Subcategory', parent: tag_type1 }
  let!(:tag2a) { create :tag, name: 'Care Co-ordination', tag_type: tag_type2, parent: tag1a }
  let!(:tag2b) { create :tag, name: 'Initial Assessment', tag_type: tag_type2, parent: tag1a }
  let!(:tag2c) { create :tag, name: 'Family Therapy Treatments', tag_type: tag_type2, parent: tag1a }

  let!(:tag2c) { create :tag, name: 'Team Meetings', tag_type: tag_type2, parent: tag1b }
  let!(:tag2d) { create :tag, name: 'Supervisions', tag_type: tag_type2, parent: tag1b }
  let!(:tag2e) { create :tag, name: 'Admin Tasks', tag_type: tag_type2, parent: tag1b }

  let!(:tag_type3) { create :tag_type, name: 'Outcomed on RiO', parent: nil }
  let!(:tag3a) { create :tag, name: 'Yes', tag_type: tag_type3, parent: nil }
  let!(:tag3b) { create :tag, name: 'No', tag_type: tag_type3, parent: nil }

  let(:user1) { create :user }
  let(:plan1) do
    create :plan, user: user1, start_date: 1.year.ago.beginning_of_month, end_date: Date.current.end_of_month, contracted_minutes_per_week: 37.5 * 60
  end

  let!(:activity1) { create :activity, plan: plan1, seconds_per_week: 8 * 3600 } # 8h
  let!(:tag_association1a) { create :tag_association, tag_type: tag_type1, tag: tag1a, taggable: activity1 }
  let!(:tag_association1b) { create :tag_association, :skip_validate, tag_type: tag_type2, tag: tag2a, taggable: activity1 }
  let!(:tag_association1c) { create :tag_association, tag_type: tag_type3, tag: tag3a, taggable: activity1 }

  let!(:activity2) { create :activity, plan: plan1, seconds_per_week: 6.5 * 3600 } # 6,5h
  let!(:tag_association2a) { create :tag_association, tag_type: tag_type1, tag: tag1b, taggable: activity2 }
  let!(:tag_association2b) { create :tag_association, :skip_validate, tag_type: tag_type2, tag: tag2b, taggable: activity2 }
  let!(:tag_association2c) { create :tag_association, :skip_validate, tag_type: tag_type3, tag: tag3b, taggable: activity2 }

  let(:user2) { create :user }
  let(:plan2) { create :plan, user: user2, start_date: 6.months.ago.beginning_of_month, end_date: 6.months.since.end_of_month }

  let!(:activity3) { create :activity, plan: plan2, seconds_per_week: 7 * 3600 } # 7h
  let!(:tag_association3a) { create :tag_association, tag_type: tag_type1, tag: tag1a, taggable: activity3 }
  let!(:tag_association3b) { create :tag_association, :skip_validate, tag_type: tag_type2, tag: tag2c, taggable: activity3 }

  it 'returns csv' do
    data = CSV.parse(subject)
    expect(data[0]).to eql ['First name', 'Last name', 'Job plan start date', 'Job plan end date', 'Job plan state',
                            'Job plan contracted hours per week', 'Job plan total hours per week',
                            'Category', 'Subcategory', 'Outcomed on RiO', 'Activity time worked per week']

    expect(data[1]).to eql [user1.first_name, user1.last_name, plan1.start_date.to_s, plan1.end_date.to_s, 'Draft', '37h 30m', '14h 30m', 'DCC',
                            'Care Co-ordination', 'Yes', '8h']
    expect(data[2]).to eql [user1.first_name, user1.last_name, plan1.start_date.to_s, plan1.end_date.to_s, 'Draft', '37h 30m', '14h 30m', 'SPA',
                            'Initial Assessment', 'No', '6h 30m']
    expect(data[3]).to eql [user2.first_name, user2.last_name, plan2.start_date.to_s, plan2.end_date.to_s, 'Draft', '0h', '7h', 'DCC', 'Team Meetings', nil,
                            '7h']
  end
end
