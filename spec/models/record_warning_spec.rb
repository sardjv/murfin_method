# == Schema Information
#
# Table name: record_warnings
#
#  id            :bigint           not null, primary key
#  warnable_id   :integer
#  warnable_type :string(255)
#  key           :string(255)
#  data          :json
#  expires_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe RecordWarning, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
