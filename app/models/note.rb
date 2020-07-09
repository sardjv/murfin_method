# == Schema Information
#
# Table name: notes
#
#  id         :bigint           not null, primary key
#  content    :text(65535)      not null
#  state      :integer          default("info"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  start_time :datetime
#  end_time   :datetime
#  author_id  :bigint
#
class Note < ApplicationRecord
  enum state: { info: 0, action: 1, resolved: 2 }

  validates :state, :content, :start_time, :end_time, :author_id, presence: true
end
