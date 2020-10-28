module Faker
  module JpStats
    class TimeRangeType < Faker::Base
      def self.name
        fetch('time_range_type.name')
      end
    end
  end
end
Faker.prepend Faker::JpStats
