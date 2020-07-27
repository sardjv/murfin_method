# == Schema Information
#
# Table name: memberships
#
#  id            :bigint           not null, primary key
#  role          :string(255)      default("member"), not null
#  user_group_id :bigint           not null
#  user_id       :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

describe Membership, type: :model do
  subject { build(:membership) }

  it { expect(subject).to be_valid }
  it { should validate_presence_of(:user_group) }
  it { should validate_presence_of(:user) }
  it { should validate_inclusion_of(:role).in_array(Membership::ROLES) }
  it { should have_db_index(%i[user_group_id user_id]).unique }
end
