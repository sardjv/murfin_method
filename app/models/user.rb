# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  first_name :string(255)      not null
#  last_name  :string(255)      not null
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

  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  def name
    "#{first_name} #{last_name}"
  end
end
