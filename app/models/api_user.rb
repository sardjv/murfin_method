# == Schema Information
#
# Table name: api_users
#
#  id                 :bigint           not null, primary key
#  name               :string(255)      not null
#  contact_email      :string(255)
#  created_by         :string(255)
#  token_generated_by :string(255)
#  token_sample       :string(255)
#  token_generated_at :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class ApiUser < ApplicationRecord
  strip_attributes only: %i[name contact_email]
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
