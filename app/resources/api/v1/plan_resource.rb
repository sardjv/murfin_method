class Api::V1::PlanResource < JSONAPI::Resource
  model_name 'Plan'
  immutable

  attributes :start_date, :end_date, :user_id

  has_many :activities, acts_as_set: true, exclude_links: :default

  filter :user_id,
         verify: lambda { |values, _context|
           values[0] = values[0].to_i
           values
         },
         apply: lambda { |records, values, _options|
           records.where(user_id: values[0])
         }
end
