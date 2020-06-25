describe DashboardPresenter do
  subject { DashboardPresenter.new(params: {}) }

  let(:user) { create(:user) }
  let(:plan_id) { create(:time_range_type, name: 'Job Plan').id }
  let(:actual_id) { create(:time_range_type, name: 'RIO Data').id }
  let!(:plan_ranges) { create_list(:time_range, 10, user_id: user.id, time_range_type_id: plan_id, value: 10) }
  let!(:actual_ranges) { create_list(:time_range, 10, user_id: user.id, time_range_type_id: actual_id, value: 5) }

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
end
