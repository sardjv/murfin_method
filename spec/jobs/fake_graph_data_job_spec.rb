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
end
