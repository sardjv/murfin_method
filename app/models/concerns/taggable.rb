module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :tag_associations, as: :taggable, dependent: :destroy
    accepts_nested_attributes_for :tag_associations, allow_destroy: true
    has_many :tag_types, through: :tag_associations
    has_many :tags, through: :tag_associations

    def active_tag_associations
      TagType.active_for(self.class).sorted.map do |tag_type|
        # tag_associations.find_by(tag_type_id: tag_type.id) || tag_associations.build(tag_type: tag_type)
        tag_associations.detect { |ta| ta.tag_type_id == tag_type.id } || tag_associations.build(tag_type: tag_type)
      end
      # detect insted find_by finds also not saved (just builded) tag associations
    end

    def self.tagged_with(tag_or_tags)
      tag_ids = tag_or_tags.respond_to?(:each) ? tag_or_tags.pluck(:id) : tag_or_tags.id
      joins(:tags).where(tags: { id: tag_ids })
    end
  end
end
