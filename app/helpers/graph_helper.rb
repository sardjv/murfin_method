module GraphHelper
  def tag_options
    TagType.includes(:tags).map { |type| [type.name, type.tags.map { |t| [t.name_with_ancestors, t.id] }] }
  end
end
