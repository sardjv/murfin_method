module Cacheable
  extend ActiveSupport::Concern

  included do
    after_update :bust
  end

  def bust
    return unless saved_changes_include?(self.class.watch)

    bust_caches # Define this on the including model.
  end

  def saved_changes_include?(attrs)
    (saved_changes.keys & attrs).any?
  end

  module ClassMethods
    attr_reader :watch

    private

    def cacheable(watch:)
      @watch = watch
    end
  end
end
