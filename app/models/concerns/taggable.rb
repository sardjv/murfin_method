module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :tag_associations, as: :taggable, dependent: :destroy
    accepts_nested_attributes_for :tag_associations, allow_destroy: true
    has_many :tag_types, through: :tag_associations
    has_many :tags, through: :tag_associations

    def build_missing_tag_associations
      TagType.active_for(self.class).find_each do |tag_type|
        # Don't use a database query here, as we need to check unsaved
        # tag_associations if validation fails.
        next if tag_associations.any? { |ta| ta.tag_type_id == tag_type.id }

        tag_associations.build(tag_type: tag_type)
      end
    end
  end
end
