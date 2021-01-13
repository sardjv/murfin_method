require 'rails_helper'

describe TimeRangeHelper do
  describe '#duration_in_words' do
    it { expect(helper.duration_in_words(0)).to eq('0 hours') }
    it { expect(helper.duration_in_words(1)).to eq('1 minute') }
    it { expect(helper.duration_in_words(45)).to eq('45 minutes') }
    it { expect(helper.duration_in_words(60)).to eq('1 hour') }
    it { expect(helper.duration_in_words(60 * 24 * 2)).to eq('48 hours') }
    it { expect(helper.duration_in_words(60 * 24 * 3 + 30)).to eq('72 hours and 30 minutes') }
  end
end
