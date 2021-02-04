class Api::V1::TagResource < JSONAPI::Resource
  model_name 'Tag'

  attributes :name, :tag_type_id, :parent_id, :default_for_filter

  filter :tag_type_id,
         verify: lambda { |values, _context|
           values[0] = values[0].to_i
           values
         },
         apply: lambda { |records, values, _options|
           records.where(tag_type_id: values[0])
         }

  filter :parent_id,
         verify: lambda { |values, _context|
           values[0] = values[0].to_i
           values
         },
         apply: lambda { |records, values, _options|
           records.where(parent_id: values[0])
         }
end
