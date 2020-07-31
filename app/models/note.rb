# == Schema Information
#
# Table name: notes
#
#  id           :bigint           not null, primary key
#  content      :text(65535)      not null
#  state        :integer          default("info"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  start_time   :datetime         not null
#  end_time     :datetime         not null
#  author_id    :bigint
#  subject_type :string(255)
#  subject_id   :bigint
#
class Note < ApplicationRecord
  enum state: { info: 0, action: 1, resolved: 2 }
  belongs_to :author, class_name: 'User'
  belongs_to :subject, polymorphic: true

  validates :state, :content, :start_time, :end_time, :author_id, :subject_id, presence: true

  def ever_updated?
    created_at != updated_at
  end

  def extra
    attributes.merge(
      author: { name: author.name },
      updated_at_readable: updated_at.strftime(I18n.t('time.formats.readable'))
    )
  end
end
