# == Schema Information
#
# Table name: plans
#
#  id                          :bigint           not null, primary key
#  start_date                  :date             not null
#  end_date                    :date             not null
#  user_id                     :bigint           not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  contracted_minutes_per_week :integer
#
FactoryBot.define do
  factory :plan do
    user_id { User.all.sample.try(:id) || create(:user).id }
    start_date { (Date.current - 1.year).beginning_of_month }
    end_date { Date.current.end_of_month }
  end
end
