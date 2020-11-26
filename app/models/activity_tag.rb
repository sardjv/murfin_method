# == Schema Information
#
# Table name: tags
#
#  id            :bigint           not null, primary key
#  content       :text(65535)      not null
#  taggable_type :string(255)
#  taggable_id   :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class ActivityTag < ApplicationRecord
  belongs_to :tag
  belongs_to :activity

  validates :tag_id, :activity_id, presence: true
  validates :activity_id, uniqueness: { scope: :tag_id }
end
