describe FakeDataJob, type: :job do
  let(:classes) { ['User', 'TimeRangeType', 'TimeRange'] }
  let(:quantity) { 2 }

  subject(:job) {
    classes.each do |klass|
      FakeDataJob.perform_later(klass: klass, quantity: quantity)
    end
  }

  context 'job' do
    before { perform_enqueued_jobs { job } }

    it 'creates records' do
      classes.each do |klass|
        expect(klass.constantize.count).to eq(2)
      end
    end
  end
end
