class Api::V1::TagAssociationResource < JSONAPI::Resource
  model_name 'TagAssociation'

  attributes :tag_id, :tag_type_id, :taggable_id, :taggable_type
end
