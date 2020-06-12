describe FakeGraphDataJob, type: :job do
  describe 'static' do
    let(:volatility) { 0 }
    subject(:job) {
      FakeGraphDataJob.perform_later(
        story: :static,
        user: create(:user),
        time_range_type: create(:time_range_type),
        graph_start_time: DateTime.new(2020).beginning_of_year,
        graph_end_time: DateTime.new(2020).end_of_year,
        unit: :week,
        volatility: volatility
      )
    }

    before { perform_enqueued_jobs { job } }

    it 'creates identical records' do
      expect(User.count).to eq(1)
      expect(TimeRange.count).to eq(53)
      expect(TimeRange.first.value).to be_an(Integer)
      expect(TimeRange.distinct.pluck(:value).count).to eq(1)
    end

    context 'with 70% volatility' do
      let(:volatility) { 0.7 }

      it 'creates varying records' do
        expect(TimeRange.count).to eq(53)
        expect(TimeRange.first.value).to be_an(Integer)
        expect(TimeRange.distinct.pluck(:value).count > 1).to eq(true)
      end
    end
  end

  describe 'seasonal_summer_and_christmas' do
    subject(:job) {
      FakeGraphDataJob.perform_later(
        story: :seasonal_summer_and_christmas,
        user: create(:user),
        time_range_type: create(:time_range_type),
        graph_start_time: DateTime.new(2020).beginning_of_year,
        graph_end_time: DateTime.new(2020).end_of_year,
        unit: :week,
        volatility: 0.5
      )
    }

    before { perform_enqueued_jobs { job } }

    it 'creates records' do
      expect(User.count).to eq(1)
      expect(TimeRange.count).to eq(53)
      expect(TimeRange.first.value).to be_an(Integer)
    end
  end

  context 'with a static plan' do
    let(:user) { create(:user) }
    let(:plan) { create(:time_range_type, name: 'plan') }
    let(:actuals) { create(:time_range_type, name: 'actuals') }

    before do
      FakeGraphDataJob.perform_now(
        story: :static,
        user: user,
        time_range_type: plan,
        graph_start_time: DateTime.new(2020).beginning_of_year,
        graph_end_time: DateTime.new(2020).end_of_year,
        unit: :week,
        volatility: 0
      )
    end

    context 'with static actuals' do
      before do
        FakeGraphDataJob.perform_now(
          story: :static,
          user: user,
          time_range_type: actuals,
          graph_start_time: DateTime.new(2020).beginning_of_year,
          graph_end_time: DateTime.new(2020).end_of_year,
          unit: :week,
          volatility: 0
        )
      end

      it 'tracks closely to the job plan' do
        differences = plan.time_ranges.map do |plan|
          (plan.value - actuals.time_ranges.find_by(start_time: plan.start_time).value).abs
        end

        expect(differences.uniq).to eq([0])
      end
    end
  end
end
