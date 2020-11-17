require 'rails_helper'

describe TimeRangeHelper do
  describe '#duration_in_words' do
    it { expect(helper.duration_in_words(60.minutes)).to eq('1 hour') }
  end
end
