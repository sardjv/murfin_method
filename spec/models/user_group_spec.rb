# == Schema Information
#
# Table name: user_groups
#
#  id            :bigint           not null, primary key
#  name          :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  group_type_id :bigint           not null
#
require 'rails_helper'

describe UserGroup, type: :model do
  subject { build(:user_group) }

  it { expect(subject).to be_valid }
  it { should validate_presence_of(:name) }
  it { should belong_to(:group_type) }
  it { should validate_presence_of(:group_type_id) }
end
