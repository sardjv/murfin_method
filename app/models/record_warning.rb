# == Schema Information
#
# Table name: record_warnings
#
#  id            :bigint           not null, primary key
#  warnable_id   :integer
#  warnable_type :string(255)
#  key           :string(255)
#  data          :json
#  expires_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class RecordWarning < ApplicationRecord
  belongs_to :warnable, polymorphic: true

  validates :key, presence: true

  store_accessor :data

  scope :not_expired, -> { where('expires_at IS NULL OR expires_at > ?', Time.current.utc) }

  def data
    super && super.is_a?(Hash) ? super.deep_symbolize_keys : (super.is_a?(Array) ? super.map(&:deep_symbolize_keys) : super)
  end
end

