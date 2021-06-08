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

  module ClassMethods
    # example logic: (tag_type1 AND (tag1a OR tag1b)) AND (tag_type2 AND (tag2a))
    # optional param context to make sure tags are active for actuals or time ranges
    def filter_by_tag_types_and_tags(filter_tag_ids) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
      context = all

      return context unless filter_tag_ids.any?

      filter_tag_ids = filter_tag_ids.collect(&:to_i)
      context_klass = context.any? ? context.first.class : nil

      pp "=========================== context_klass: #{context_klass}"

      if context_klass
        tag_type_ids_active_for_context = TagType.active_for(context_klass.name.tableize).pluck(:id)
        pp 'tag_type_ids_active_for_context ', tag_type_ids_active_for_context
        tag_ids_active_for_context = Tag.where(id: filter_tag_ids, tag_type_id: tag_type_ids_active_for_context).pluck(:id)
        pp 'tag_ids_active_for_context ', tag_ids_active_for_context
        filter_tag_ids &= tag_ids_active_for_context
        pp 'AFTER filter_tag_ids', tag_ids_active_for_context
      end

      return context unless filter_tag_ids.any?

      tags_by_tag_type = (filter_tag_ids.any? ? Tag.where(id: filter_tag_ids) : Tag.all)
                         .select(:id, :tag_type_id)
                         .group_by(&:tag_type_id)
                         .transform_values { |tgs| tgs.pluck(:id) }

pp 'tags_by_tag_type', tags_by_tag_type

      taggable_ids = []
      i = 0
      tags_by_tag_type.each_pair do |tag_type_id, tag_ids|
        tmp_taggable_ids = TagAssociation.where(taggable: context).where(tag_id: tag_ids, tag_type_id: tag_type_id).pluck('DISTINCT(taggable_id)')
        pp "tag_type_id: #{tag_type_id} | tag_ids: #{tag_ids} | tmp_taggable_ids: #{tmp_taggable_ids}"
        taggable_ids = i.zero? ? tmp_taggable_ids : (taggable_ids & tmp_taggable_ids)

        i += 1
      end

      pp 'taggable_ids', taggable_ids

      context.where(id: taggable_ids)
    end
  end
end
