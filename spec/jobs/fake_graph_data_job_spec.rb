describe FakeGraphDataJob, type: :job do
  describe 'static' do
    let(:volatility) { 0 }
    subject(:job) do
      FakeGraphDataJob.perform_later(
        story: :static,
        user_id: create(:user).id,
        time_range_type_id: create(:time_range_type).id,
        start: DateTime.new(2020),
        volatility: volatility
      )
    end

    before { perform_enqueued_jobs { job } }

    it 'creates identical records' do
      expect(User.count).to eq(1)
      expect(TimeRange.count).to eq(52)
      expect(TimeRange.first.value).to be_an(Integer)
      expect(TimeRange.distinct.pluck(:value).count).to eq(1)
    end

    context 'with 70% volatility' do
      let(:volatility) { 0.7 }

      it 'creates varying records' do
        expect(TimeRange.count).to eq(52)
        expect(TimeRange.first.value).to be_an(Integer)
        expect(TimeRange.distinct.pluck(:value).count > 1).to eq(true)
      end
    end
  end

  describe 'seasonal_summer_and_christmas' do
    subject(:job) do
      FakeGraphDataJob.perform_later(
        story: :seasonal_summer_and_christmas,
        user_id: create(:user).id,
        time_range_type_id: create(:time_range_type).id,
        start: DateTime.new(2020),
        volatility: 0.5
      )
    end

    before { perform_enqueued_jobs { job } }

    it 'creates records' do
      expect(User.count).to eq(1)
      expect(TimeRange.count).to eq(52)
      expect(TimeRange.first.value).to be_an(Integer)
    end
  end

  context 'with a static plan' do
    let(:user) { create(:user) }
    let(:actuals) { create(:time_range_type, name: 'actuals') }
    let!(:plan) do
      create(
        :plan,
        user_id: user.id,
        start_date: DateTime.new(2020, 1, 6), # First Monday of year.
        end_date: DateTime.new(2020).end_of_year,
        activities: [create(:activity)]
      )
    end

    context 'with static actuals' do
      before do
        FakeGraphDataJob.perform_now(
          story: :static,
          user_id: user.id,
          time_range_type_id: actuals.id,
          start: DateTime.new(2020),
          volatility: actuals_volatility
        )
      end

      context 'with 0% volatility' do
        let(:actuals_volatility) { 0.0 }
        it 'matches the job plan exactly' do
          expect(differences(actuals: actuals, plan: plan).uniq).to eq([0])
        end
      end

      context 'with 2% volatility' do
        let(:actuals_volatility) { 0.02 }
        it 'tracks the job plan closely' do
          expect(differences(actuals: actuals, plan: plan).max).to be <= 5
        end
      end
    end

    context 'with seasonal actuals' do
      before do
        FakeGraphDataJob.perform_now(
          story: :seasonal_summer_and_christmas,
          user_id: user.id,
          time_range_type_id: actuals.id,
          start: DateTime.new(2020),
          volatility: actuals_volatility
        )
      end

      context 'with 0% volatility' do
        let(:actuals_volatility) { 0.0 }
        it 'tracks the job plan very closely' do
          expect(differences(actuals: actuals, plan: plan).max).to be <= 10
        end
      end

      context 'with 20% volatility' do
        let(:actuals_volatility) { 0.20 }
        it 'tracks the job plan less closely' do
          expect(differences(actuals: actuals, plan: plan).max).to be <= 48
        end
      end

      context 'with 50% volatility' do
        let(:actuals_volatility) { 0.5 }

        it 'has seasonality' do
          plan.to_time_ranges.each do |p|
            difference = p.value - actuals.time_ranges.select do |a|
              intersection(actual: a, plan: p).positive?
            end.sum(&:value).abs

            expect(difference).to be <= 10 unless %w[June July December].include?(plan.start_time.strftime('%B'))
          end
        end
      end
    end
  end
end

def differences(actuals:, plan:)
  plan.to_time_ranges.map do |p|
    (p.value - actuals.time_ranges.sum do |a|
      (a.value * intersection(actual: a, plan: p)).round
    end).abs
  end
end

def intersection(actual:, plan:)
  Intersection.call(
    a_start: actual.start_time.beginning_of_day,
    a_end: actual.end_time.end_of_day,
    b_start: plan.start_time.beginning_of_day,
    b_end: plan.end_time.end_of_day
  )
end
