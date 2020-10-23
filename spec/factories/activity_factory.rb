# == Schema Information
#
# Table name: activities
#
#  id         :bigint           not null, primary key
#  schedule   :text(16777215)   not null
#  plan_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :activity do
    schedule do
      IceCube::Schedule.new do |s|
        s.add_recurrence_rule(IceCube::Rule.weekly.day(:monday))
      end
    end
    plan_id { Plan.all.sample.try(:id) || create(:plan).id }
  end
end
