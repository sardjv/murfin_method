module CacheBuster
  extend ActiveSupport::Concern

  included do
    after_update :bust_caches
  end

  def saved_changes_include?(attrs)
    (saved_changes.keys & attrs).any?
  end
end
