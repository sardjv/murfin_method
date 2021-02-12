class Api::V1::UserGroupResource < JSONAPI::Resource
  model_name 'UserGroup'

  attributes :name, :group_type_id

  filter :name,
         apply: lambda { |records, values, _options|
           records.where("name LIKE '%%%s%%'", values[0])
         }

  filter :group_type_id,
         verify: lambda { |values, _context|
           values[0] = values[0].to_i
           values
         },
         apply: lambda { |records, values, _options|
           records.where(group_type_id: values[0])
         }
end
