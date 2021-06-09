module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :tag_associations, as: :taggable, dependent: :destroy
    accepts_nested_attributes_for :tag_associations, allow_destroy: true, reject_if: proc { |attrs| attrs['tag_id'].blank? }
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

  module ClassMethods
    # example logic: (tag_type1 AND (tag1a OR tag1b)) AND (tag_type2 AND (tag2a))
    def filter_by_tag_types_and_tags(filter_tag_ids) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      scope = all
      scope_klass = scope.any? ? scope.first.class : nil
      tags_by_tag_type = Tag.where(id: filter_tag_ids).group_by(&:tag_type)

      taggable_ids = []
      i = 0
      tags_by_tag_type.each_pair do |tag_type, tags|
        next if scope_klass == TimeRange && !tag_type.active_for_time_ranges
        next if scope_klass == Activity && !tag_type.active_for_activities

        tags = Array.wrap(tags)
        tag_ids = tags.collect(&:id)

        tmp_taggable_ids = TagAssociation.where(taggable: scope).where(tag_id: tag_ids, tag_type_id: tag_type.id).pluck('DISTINCT(taggable_id)')
        taggable_ids = i.zero? ? tmp_taggable_ids : (taggable_ids & tmp_taggable_ids)

        i += 1
      end

      scope.where(id: taggable_ids)
    end
  end
end
