module Cacheable
  extend ActiveSupport::Concern

  included do
    after_save :bust_caches_if_watched
    after_destroy :bust_caches
  end

  private

  def bust_caches_if_watched
    return unless saved_changes_include?(self.class.watch)

    bust_caches
  end

  def bust_caches
    self.class.bust.each do |bustable|
      CacheBusterJob.perform_later(klass: bustable[:klass], ids: send_chain(bustable[:ids]))
    end
  end

  def saved_changes_include?(attrs)
    (saved_changes.keys & attrs).any?
  end

  def send_chain(methods)
    [*methods].inject(self) { |object, method| object.send(method) }
  end

  module ClassMethods
    attr_reader :watch, :bust

    private

    def cacheable(watch:, bust:)
      @watch = watch
      @bust = bust
    end
  end
end
