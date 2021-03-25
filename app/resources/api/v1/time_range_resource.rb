class Api::V1::TimeRangeResource < JSONAPI::Resource
  model_name 'TimeRange'

  attributes :start_time, :end_time, :user_id, :time_range_type_id, :appointment_id
  attribute :minutes_worked, delegate: :value

  def minutes_worked
    @model.value.to_i
  end

  has_many :tags, acts_as_set: true, exclude_links: :default

  filter :appointment_id,
         apply: lambda { |records, values, _options|
           records.where(appointment_id: values[0])
         }

  filter :user_id,
         verify: lambda { |values, _context|
           values[0] = values[0].to_i
           values
         },
         apply: lambda { |records, values, _options|
           records.where(user_id: values[0])
         }

  filter :time_range_type_id,
         verify: lambda { |values, _context|
           values[0] = values[0].to_i
           values
         },
         apply: lambda { |records, values, _options|
           records.where(time_range_type_id: values[0])
         }
end
