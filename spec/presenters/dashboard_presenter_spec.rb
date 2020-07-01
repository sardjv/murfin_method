describe DashboardPresenter do
  subject { DashboardPresenter.new(params: {}) }

  before :all do
    Timecop.freeze(Time.zone.local(2020, 6, 26, 14))
  end

  let(:user) { create(:user) }
  let(:plan_id) { TimeRangeType.plan_type.id }
  let(:actual_id) { TimeRangeType.actual_type.id }

  let(:plan_start_time) { 1.week.ago }
  let(:plan_end_time) { Time.zone.now }
  let(:actual_start_time) { 1.week.ago }
  let(:actual_end_time) { Time.zone.now }

  let!(:plan_ranges) do
    create_list(
      :time_range,
      10,
      user_id: user.id,
      time_range_type_id: plan_id,
      start_time: plan_start_time,
      end_time: Time.zone.now,
      value: 10
    )
  end
  let!(:actual_ranges) do
    create_list(
      :time_range,
      10,
      user_id: user.id,
      time_range_type_id: actual_id,
      start_time: plan_start_time,
      end_time: Time.zone.now,
      value: 5
    )
  end

  describe 'bar_chart' do
    it 'returns the actuals as a percentage of plan delivered' do
      expect(subject.bar_chart(
               user_ids: [user.id],
               plan_id: plan_id,
               actual_id: actual_id
             )).to eq(
               [
                 {
                   name: user.name,
                   value: 50
                 }
               ]
             )
    end
  end

  describe 'line_graph' do
    it 'returns the actuals as a percentage of plan delivered, per month, for the team' do
      expect(subject.line_graph(
               user_ids: [user.id],
               plan_id: plan_id,
               actual_id: actual_id
             )).to eq(
               [
                 { name: 'June', value: 0 },
                 { name: 'July', value: 0 },
                 { name: 'August', value: 0 },
                 { name: 'September', value: 0 },
                 { name: 'October', value: 0 },
                 { name: 'November', value: 0 },
                 { name: 'December', value: 0 },
                 { name: 'January', value: 0 },
                 { name: 'February', value: 0 },
                 { name: 'March', value: 0 },
                 { name: 'April', value: 0 },
                 { name: 'May', value: 0 },
                 { name: 'June', value: 50.21 }
               ]
             )
    end
  end
end
