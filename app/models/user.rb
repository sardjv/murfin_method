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
end
