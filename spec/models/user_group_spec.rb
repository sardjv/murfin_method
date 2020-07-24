# == Schema Information
#
# Table name: user_groups
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

describe UserGroup, type: :model do
  subject { build(:user_group) }

  it { expect(subject).to be_valid }
  it { should validate_presence_of(:name) }
end
