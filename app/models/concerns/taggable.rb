module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :tag_associations, as: :taggable, dependent: :destroy
    accepts_nested_attributes_for :tag_associations, allow_destroy: true
    has_many :tag_types, through: :tag_associations
    has_many :tags, through: :tag_associations

    def tag_associations
      @cached_tag_associations = super
      TagType.active_for(self.class).sorted.map do |tag_type|
        @cached_tag_associations.where(tag_type_id: tag_type.id).first || @cached_tag_associations.build(tag_type: tag_type)
      end
    end
  end
end
