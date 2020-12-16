describe DashboardPresenter do
  subject do
    DashboardPresenter.new(
      params: {
        user_ids: [user.id],
        actual_id: actual_id,
        filter_start_month: '10',
        filter_start_year: '2019',
        filter_end_month: '6',
        filter_end_year: '2020'
      }
    )
  end

  before :all do
    Timecop.freeze(Time.zone.local(2020, 6, 30, 23, 59, 59))
  end

  after :all do
    Timecop.return
  end

  let(:user) { create(:user) }
  let(:actual_id) { TimeRangeType.actual_type.id }

  let!(:plan_ranges) do
    create(
      :plan,
      user_id: user.id,
      start_date: Time.zone.now.beginning_of_month,
      end_date: Time.zone.now,
      activities: [create(:activity)] # 4 hours per week.
    )
  end
  let!(:actual_ranges) do
    create(
      :time_range,
      user_id: user.id,
      time_range_type_id: actual_id,
      start_time: Time.zone.now.beginning_of_month,
      end_time: Time.zone.now,
      value: 480 # About 2 hours per week.
    )
  end

  describe 'to_json' do
    context 'with :admin data' do
      it 'returns a multi-line graph' do
        data = JSON.parse(
          subject.to_json(
            graphs: [{ type: :line_graph, data: :admin_data }]
          )
        )['line_graph']['data']

        expect(data.count).to eq(4)
        expect(data.flatten.flat_map(&:keys).uniq).to match_array(%w[name value notes])
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
                { name: '2019-10-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2019-11-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2019-12-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2020-01-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2020-02-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2020-03-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2020-04-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2020-05-01T00:00:00.000Z', value: 0, notes: '[]' },
                { name: '2020-06-01T00:00:00.000Z', value: 46.67, notes: '[]' }
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
                  value: '47.0'
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
