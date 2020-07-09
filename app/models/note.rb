# == Schema Information
#
# Table name: notes
#
#  id         :bigint           not null, primary key
#  content    :text(65535)      not null
#  state      :integer          default("info"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Note < ApplicationRecord
  enum state: { info: 0, action: 1, resolved: 2 }

  validates :state, :content, presence: true
end
