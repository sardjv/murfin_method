# Summary:
# - Adds the ability to make a model 'active' related to other classes.
#
# Requirements:
# - A migration to add a datetime for each related
#   class with column name e.g. "active_for_activities_at".
# - A list of activatable classes in the model
#   e.g. activatable classes: %w[activities time_ranges]
#
# Adds:
# - Setters (e.g. TagType.update(active_for_activity: true))
# - Setters for checkboxes (e.g. TagType.update(active_for_activity: '1'))
# - Getters (e.g. TagType.active_for_activity)
# - Getters (e.g. TagType.active_for_activity?)
# - Scopes (e.g. TagType.active_for(Activity))
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
        # Setter.
        define_method "active_for_#{activatable}=" do |state|
          assign_attributes("active_for_#{activatable}_at" => (Activatable.checked?(state) ? Time.current : nil))
        end

        # Getter.
        define_method "active_for_#{activatable}" do
          send("active_for_#{activatable}_at").present?
        end
        alias_method :"active_for_#{activatable}?", :"active_for_#{activatable}"
      end
    end
  end
end
