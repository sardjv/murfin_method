# == Schema Information
#
# Table name: memberships
#
#  id            :bigint           not null, primary key
#  role          :integer          default("member"), not null
#  user_group_id :bigint           not null
#  user_id       :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

describe Membership, type: :model do
  subject { build(:membership) }

  it { expect(subject).to be_valid }
  it { should belong_to(:user) }
  it { should belong_to(:user_group) }
  it { should validate_presence_of(:role) }
  it { should have_db_index(%i[user_group_id user_id]).unique }
end
