# Import some test data for demonstration purposes.

FakeDataJob.perform_later(klass: 'User', quantity: 20)
FakeDataJob.perform_later(klass: 'TimeRangeType', quantity: 20)
FakeDataJob.perform_later(klass: 'TimeRange', quantity: 2000)
