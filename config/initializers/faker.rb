module Faker::Murfin
  class TimeRangeType < Faker::Base
    def self.name
      fetch('time_range_type.name')
    end
  end
end
Faker.prepend Faker::Murfin
