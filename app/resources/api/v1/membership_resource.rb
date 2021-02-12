class Api::V1::MembershipResource < JSONAPI::Resource
  model_name 'Membership'

  attributes :user_id, :user_group_id, :role

  exclude_links [:self]
end
