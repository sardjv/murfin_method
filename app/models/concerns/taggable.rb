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
    # optional param context to make sure tags are active for actuals or time ranges
    def filter_by_tag_types_and_tags(filter_tag_ids) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      context = all
      context_klass_name = name

      return context if filter_tag_ids.blank?

      filter_tag_ids = filter_tag_ids.collect(&:to_i)

      tags_by_tag_type = (filter_tag_ids.any? ? Tag.where(id: filter_tag_ids) : Tag.all)
                         .select(:id, :tag_type_id)
                         .group_by(&:tag_type_id)
                         .transform_values { |tgs| tgs.pluck(:id) }

      tag_type_ids_active_for_context = TagType.active_for(context_klass_name.tableize).pluck(:id)

      # remove tag types not active for context
      tags_by_tag_type.keep_if { |k| tag_type_ids_active_for_context.include?(k) }

      return context if tags_by_tag_type.empty? # no active tag types for current context

      taggable_ids = []
      i = 0
      tags_by_tag_type.each_pair do |tag_type_id, tag_ids|
        tmp_taggable_ids = TagAssociation.where(taggable_type: context_klass_name).where(tag_id: tag_ids,
                                                                                         tag_type_id: tag_type_id).pluck('DISTINCT(taggable_id)')
        taggable_ids = i.zero? ? tmp_taggable_ids : (taggable_ids & tmp_taggable_ids)

        i += 1
      end

      context.where(id: taggable_ids)
    end
  end
end
