# == Schema Information
#
# Table name: time_range_types
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TimeRangeType < ApplicationRecord
  has_many :time_ranges, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def self.actual_type
    @actual_type ||= TimeRangeType.find_by(name: 'RIO Data')
  end
end
