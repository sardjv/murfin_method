describe DashboardPresenter do
  subject do
    DashboardPresenter.new(
      params: {
        user_ids: [user.id],
        plan_id: plan_id,
        actual_id: actual_id
      }
    )
  end

  before :all do
    Timecop.freeze(Time.zone.local(2020, 6, 26, 14))
  end

  let(:user) { create(:user) }
  let(:plan_id) { TimeRangeType.plan_type.id }
  let(:actual_id) { TimeRangeType.actual_type.id }

  let!(:plan_ranges) do
    create_list(
      :time_range,
      10,
      user_id: user.id,
      time_range_type_id: plan_id,
      start_time: 1.week.ago,
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
      start_time: 1.week.ago,
      end_time: Time.zone.now,
      value: 5
    )
  end

  describe 'to_json' do
    context 'with :admin data' do
      it 'returns a multi-line graph' do
        expect(
          JSON.parse(
            subject.to_json(
              graphs: [{ type: :line_graph, data: :admin_data }]
            )
          )['line_graph'].count
        ).to eq(4)
      end
    end

    context 'with :team data' do
      it 'returns a line graph' do
        expect(
          subject.to_json(
            graphs: [{ type: :line_graph, data: :team_data }]
          )
        ).to eq(
          {
            line_graph: [[
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
            ]]
          }.to_json
        )
      end
    end

    context 'with :individual data' do
      it 'returns a bar chart' do
        expect(
          subject.to_json(
            graphs: [{ type: :bar_chart, data: :individual_data }]
          )
        ).to eq(
          {
            bar_chart: [
              {
                name: user.name,
                value: 50
              }
            ]
          }.to_json
        )
      end
    end
  end
end
