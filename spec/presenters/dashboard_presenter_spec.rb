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
          )['line_graph']['data'].count
        ).to eq(4)
      end
    end

    context 'with :team data' do
      it 'returns a line graph' do
        expect(
          subject.to_json(
            graphs: [{ type: :line_graph, data: :team_data, units: '%' }]
          )
        ).to eq(
          {
            line_graph: {
              data: [[
                { name: '2019-06-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2019-07-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2019-08-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2019-09-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2019-10-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2019-11-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2019-12-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2020-01-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2020-02-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2020-03-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2020-04-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2020-05-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2020-06-01T00:00:00.000Z', value: 50.21, notes: '[]' }
              ]],
              units: '%'
            }
          }.to_json
        )
      end
    end

    context 'with :individual data' do
      it 'returns a bar chart' do
        expect(
          subject.to_json(
            graphs: [{ type: :bar_chart, data: :individual_data, units: '%' }]
          )
        ).to eq(
          {
            bar_chart: {
              data: [
                {
                  name: user.name,
                  value: 50
                }
              ],
              units: '%'
            }
          }.to_json
        )
      end
    end
  end
end
