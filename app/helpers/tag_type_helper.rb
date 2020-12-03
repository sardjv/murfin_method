module TagTypeHelper
  def self.visible_options_count(tag_type)
    [tag_type.tags.count + 1, 10].min
  end
end
