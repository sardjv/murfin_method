describe DashboardPresenter, freeze: Time.zone.local(2020, 6, 30, 23, 59, 59) do
  subject do
    DashboardPresenter.new(
      params: presenter_params
    )
  end

  let(:default_presenter_params) do
    {
      user_ids: [user.id],
      actual_id: actual_id,
      filter_start_month: '10',
      filter_start_year: '2019',
      filter_end_month: '6',
      filter_end_year: '2020',
      filter_tag_ids: filter_tag_ids
    }
  end

  let(:presenter_params) { default_presenter_params }

  # replicate how filter_tag_ids sent from line_graph.js
  let(:filter_tag_ids) { tag1.id.to_s }

  let(:user) { create(:user) }
  let(:actual_id) { TimeRangeType.actual_type.id }
  let(:tag1) { create(:tag) }

  let!(:plan) do
    create(:plan,
           user_id: user.id,
           start_date: Time.current.beginning_of_month,
           end_date: Time.current)
  end
  let!(:activity) { create(:activity, plan: plan) }
  let!(:tag_associations) { [create(:tag_association, taggable: activity, tag: tag1, tag_type: tag1.tag_type)] }

  let!(:actual_ranges) do
    create(
      :time_range,
      user_id: user.id,
      time_range_type_id: actual_id,
      start_time: Time.current.beginning_of_month,
      end_time: Time.current,
      tag_associations: [
        build(:tag_association, tag: tag1, tag_type: tag1.tag_type)
      ],
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
      context 'parcentage delivered' do
        let(:presenter_params) { default_presenter_params.merge({ graph_kind: 'percentage_delivered' }) }
        let(:graphs_params) { [{ type: :line_graph, data: :team_data, units: '%' }] }

        it 'returns a line graph' do
          expect(subject.to_json(graphs: graphs_params)).to eq(
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

      context 'planned vs actual' do
        let(:presenter_params) { default_presenter_params.merge({ graph_kind: 'planned_vs_actual' }) }
        let(:dataset_labels) { [Faker::Lorem.sentence, Faker::Lorem.sentence] }
        let(:graphs_params) { [{ type: :line_graph, data: :team_data, units: 'minutes', dataset_labels: dataset_labels }] }

        it 'returns a line graph' do
          expect(subject.to_json(graphs: graphs_params)).to eq(
            {
              line_graph: {
                data: [
                  [
                    { name: '2019-10-01T00:00:00.000Z', value: 0, notes: '[]' },
                    { name: '2019-11-01T00:00:00.000Z', value: 0, notes: '[]' },
                    { name: '2019-12-01T00:00:00.000Z', value: 0, notes: '[]' },
                    { name: '2020-01-01T00:00:00.000Z', value: 0, notes: '[]' },
                    { name: '2020-02-01T00:00:00.000Z', value: 0, notes: '[]' },
                    { name: '2020-03-01T00:00:00.000Z', value: 0, notes: '[]' },
                    { name: '2020-04-01T00:00:00.000Z', value: 0, notes: '[]' },
                    { name: '2020-05-01T00:00:00.000Z', value: 0, notes: '[]' },
                    { name: '2020-06-01T00:00:00.000Z', value: 240.0, notes: '[]' }
                  ],
                  [
                    { name: '2019-10-01T00:00:00.000Z', value: 0, notes: '[]' },
                    { name: '2019-11-01T00:00:00.000Z', value: 0, notes: '[]' },
                    { name: '2019-12-01T00:00:00.000Z', value: 0, notes: '[]' },
                    { name: '2020-01-01T00:00:00.000Z', value: 0, notes: '[]' },
                    { name: '2020-02-01T00:00:00.000Z', value: 0, notes: '[]' },
                    { name: '2020-03-01T00:00:00.000Z', value: 0, notes: '[]' },
                    { name: '2020-04-01T00:00:00.000Z', value: 0, notes: '[]' },
                    { name: '2020-05-01T00:00:00.000Z', value: 0, notes: '[]' },
                    { name: '2020-06-01T00:00:00.000Z', value: 112.0, notes: '[]' }
                  ]
                ],
                units: 'minutes',
                dataset_labels: dataset_labels
              }
            }.to_json
          )
        end
      end
    end

    context 'with :individual data' do
      let(:filter_tag_ids) { [tag1.id] }
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
                  value: 47
                }
              ],
              units: '%'
            }
          }.to_json
        )
      end
    end
  end

  describe 'users_with_job_plan_count' do
    it 'returns number of users' do
      expect(subject.users_with_job_plan_count).to eql 1
    end
  end

  context 'when have a second activity with a different tag' do
    let(:tag2) { create(:tag) }
    let!(:activity2) { create(:activity, plan: plan) }
    let!(:tag_associations2) { [create(:tag_association, taggable: activity2, tag: tag2, tag_type: tag2.tag_type)] }

    context 'when filter by one tag' do
      let(:filter_tag_ids) { [tag1.id] }

      it 'returns filtered data' do
        expect(subject.team_stats_presenter.average_weekly_planned_per_month.last[:value]).to eq 240.0
        expect(subject.team_stats_presenter.average_weekly_actual_per_month.last[:value]).to eq 112.0
        expect(subject.team_stats_presenter.weekly_percentage_delivered_per_month.last[:value]).to eq 46.67
      end
    end

    context 'when filter by more than one tag' do
      let(:filter_tag_ids) { [tag1.id, tag2.id] }
      
      it 'returns filtered data' do
        expect(subject.team_stats_presenter.average_weekly_planned_per_month.last[:value]).to eq 480.0
        expect(subject.team_stats_presenter.average_weekly_actual_per_month.last[:value]).to eq 112.0
        expect(subject.team_stats_presenter.weekly_percentage_delivered_per_month.last[:value]).to eq 23.33
      end
    end
  end
end
