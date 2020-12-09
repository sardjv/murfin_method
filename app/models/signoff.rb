# == Schema Information
#
# Table name: signoffs
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  signed_at  :datetime
#  revoked_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Signoff < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  def sign
    update(signed_at: Time.current)
  end

  def revoke
    update(revoked_at: Time.current)
  end

  def signed?
    return false if signed_at.nil?

    return true if revoked_at.nil?

    signed_at > revoked_at
  end
end
