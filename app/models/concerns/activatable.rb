# Adds the ability to make a model 'active' related to other classes.
#
# Requirements:
# - A migration to add a boolean for each related
# class with column name e.g. "active_for_activities_at".
# - A list of activatable classes in the model
#   e.g. activatable classes: %w[activities time_ranges]
#
# Adds:
# - Setter (e.g. TagType.update(active_for_activity: true))
# - Setter (e.g. TagType.update(active_for_activity: '1'))
# - Getter (e.g. TagType.active_for_activity?)
# - Scope (e.g. TagType.active_for(Activity))
module Activatable
  extend ActiveSupport::Concern

  included do
    scope :active_for, ->(type) { where("active_for_#{type.to_s.underscore.pluralize}_at" => ..Time.current) }
  end

  def self.checked?(state)
    %w[1 true].include?(state.to_s)
  end

  module ClassMethods
    private

    def activatable(classes:)
      classes.each do |activatable|
        define_method "active_for_#{activatable}=" do |state|
          assign_attributes("active_for_#{activatable}_at" => (Activatable.checked?(state) ? Time.current : nil))
        end

        define_method "active_for_#{activatable}"  do
          send("active_for_#{activatable}_at").present?
        end

        define_method "active_for_#{activatable}?"  do
          send("active_for_#{activatable}")
        end
      end
    end
  end
end
