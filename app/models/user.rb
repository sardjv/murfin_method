# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  has_many :time_ranges, dependent: :destroy
  has_many :notes, as: :subject, dependent: :destroy
  has_many(
    :notes_written,
    foreign_key: 'author_id',
    class_name: 'Note',
    dependent: :restrict_with_exception,
    inverse_of: 'author'
  )

  def name
    "#{first_name} #{last_name}"
  end
end
