# == Schema Information
#
# Table name: notes
#
#  id         :bigint           not null, primary key
#  content    :text(65535)      not null
#  state      :integer          default("info"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  start_time :datetime
#  end_time   :datetime
#  author_id  :bigint
#
FactoryBot.define do
  factory :note do
    content { Faker::Lorem.sentences }
    start_time { Faker::Time.between(from: DateTime.now - 1.year, to: DateTime.now + 1.year) }
    author_id { User.all.sample.try(:id) || create(:user).id }

    after(:build) do |note|
      # Set end_time to be the same as start_time.
      note.end_time = note.start_time unless note.end_time
    end
  end
end
