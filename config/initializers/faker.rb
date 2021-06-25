class Faker::Murfin::TimeRangeType < Faker::Base
  def self.name
    fetch('time_range_type.name')
  end
end
Faker.prepend Faker::Murfin
