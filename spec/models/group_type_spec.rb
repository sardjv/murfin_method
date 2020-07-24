# == Schema Information
#
# Table name: group_types
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

describe GroupType, type: :model do
  subject { build(:group_type) }

  it { expect(subject).to be_valid }
  it { should validate_presence_of(:name) }
end
